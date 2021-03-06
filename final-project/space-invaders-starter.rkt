;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders


;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define MTS (empty-scene 300 500))

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))



;; Data Definitions:

(define-struct game (invaders missiles t))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dx t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 200 22))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right
(define I4 (make-invader 150 (+ HEIGHT 20) 10)) ;> landed, moving right


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))


;; ListOfInvader is one of:
;;  - empty
;;  - (cons Number ListOfInvader)
;; interp. each invader in the list a invader on screen
(define LOI1 empty)
(define LOI2 (cons I1 empty))
(define LOI3 (cons I1 (cons I2 (cons I3 empty))))
(define LOI4 (cons I1 (cons I2 (cons I3 (cons I4 empty)))))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))



(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))


;; Game -> Game
;; Run the world with the (listof Invader) (listof Missile) Tank
;; Start with: (main (make-game (list I1) empty (make-tank 50 1)))
(define (main g)
  (big-bang g                         ; Game
            (on-tick   next-tock)     ; Game -> Game
            (to-draw   render)        ; Game -> Image
            (on-key    fire)))        ; Game KeyEvent -> Game

;; Game -> Game
;; Produce the next stage of the game
(check-expect (next-tock (make-game (list I1) (list M1) T1)) (make-game (list I1) (list M1) T1))
(define (next-tock g) g) ;stub

;; ListOfInvader -> ListOfInvader
;; Add randomly an invader to the list of invaders
(check-expect (add-invader LOI2) (add-invader LOI2))
;(define (add-invader li) li); stub
(define (add-invader loi) 
  (cond [(empty? loi) empty]
        [else
         (if (= (modulo (length loi) 4) 0) 
             (cons I1 loi)
             loi)]))


;; Game -> Image
;; Produce the game image with the tank, invaders and missils fired
;(define (render g) (place-image TANK 100 100 MTS))  ;stub
(define (render g)
  (beside  (place-image INVADER
                       TANK-HEIGHT/2
                       TANK-HEIGHT/2
                       (rectangle 148 148 "solid" "gray"))
          (place-image TANK
                       (tank-x (game-t g))
                       TANK-HEIGHT/2
                       (rectangle 148 148 "solid" "gray")))) ;stub2

;; Template from KeyEvent
;; Fire the missil from the current position of the tank
(define (fire g key) g) ;stub
