
(load-extension "./ts_sdl2")
(sdl2-init)

(load "event-handling.scm")
(add-event-handler sdl2-quit (lambda (event) #f))

(define (println . args)
  (map display args)
  (display "\n"))

(let* ((window (sdl2-create-window))
       (renderer (sdl2-create-renderer window))
       (texture (sdl2-load-texture renderer
                 "/home/gmcnutt/Dropbox/projects/art/iso-64x64-outside.png"))
       )
  (define (clear-screen)
    (sdl2-set-render-draw-color renderer 255 255 255 sdl2-alpha-opaque)
    (sdl2-render-clear renderer))
  (define (render)
    (clear-screen)
    (sdl2-render-present renderer)
    )
  (define (loop frames event)
    (render)
    (cond ((not (handle-event event)) frames)
          (else
           (loop (+ frames 1)
                 (sdl2-poll-event)))))

  (add-event-handler sdl2-mouse-button-down
                     (lambda (event x y)
                       (let ((loc (iso-screen-to-map x y)))
                         (if (not (null? loc))
                             (begin
                               (set-cdr! rocks (insert-2d (cdr rocks) loc))
                               )))
                       #t))

  ;; Start the main loop and time the FPS.
  (let ((start (sdl2-get-ticks))
        (frames (loop 0 (sdl2-poll-event)))
        (stop (sdl2-get-ticks)))
    (println (/ (* frames 1000) (- stop start)) " FPS"))

  (sdl2-destroy-texture texture)
  (sdl2-destroy-renderer renderer)
  (sdl2-destroy-window window)
  )

