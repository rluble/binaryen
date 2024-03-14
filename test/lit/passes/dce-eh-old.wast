;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --dce -all -S -o - | filecheck %s

;; If either try body or catch body is reachable, the whole try construct is
;; reachable
(module
  ;; CHECK:      (tag $e)
  (tag $e)

  ;; CHECK:      (tag $e-i32 (param i32))
  (tag $e-i32 (param i32))

  ;; CHECK:      (func $foo (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo)

  ;; CHECK:      (func $try_unreachable (type $0)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch_all
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT: )
  (func $try_unreachable
    (try
      (do
        (unreachable)
      )
      (catch_all)
    )
    (call $foo) ;; shouldn't be dce'd
  )

  ;; CHECK:      (func $catch_unreachable (type $0)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch_all
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT: )
  (func $catch_unreachable
    (try
      (do)
      (catch_all
        (unreachable)
      )
    )
    (call $foo) ;; shouldn't be dce'd
  )

  ;; CHECK:      (func $both_unreachable (type $0)
  ;; CHECK-NEXT:  (try $try
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch_all
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $both_unreachable
    (try
      (do
        (unreachable)
      )
      (catch_all
        (unreachable)
      )
    )
    (call $foo) ;; should be dce'd
  )

  ;; CHECK:      (func $throw (type $0)
  ;; CHECK-NEXT:  (block $label$0
  ;; CHECK-NEXT:   (block $label$1
  ;; CHECK-NEXT:    (throw $e)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $throw
    ;; All these wrapping expressions before 'throw' will be dce'd
    (drop
      (block $label$0 (result externref)
        (if
          (i32.clz
            (block $label$1 (result i32)
              (throw $e)
            )
          )
          (then
            (nop)
          )
        )
        (ref.null extern)
      )
    )
  )

  ;; CHECK:      (func $rethrow (type $0)
  ;; CHECK-NEXT:  (try $l0
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (i32.const 0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (rethrow $l0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $rethrow
    (try $l0
      (do)
      (catch $e
        (drop
          ;; This i32.add will be dce'd
          (i32.add
            (i32.const 0)
            (rethrow $l0)
          )
        )
      )
    )
  )

  ;; CHECK:      (func $call-pop-catch (type $0)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (block $label
  ;; CHECK-NEXT:   (try $try
  ;; CHECK-NEXT:    (do
  ;; CHECK-NEXT:     (nop)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (catch $e-i32
  ;; CHECK-NEXT:     (local.set $0
  ;; CHECK-NEXT:      (pop i32)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (block
  ;; CHECK-NEXT:      (block
  ;; CHECK-NEXT:       (drop
  ;; CHECK-NEXT:        (local.get $0)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (br $label)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $call-pop-catch
    (block $label
     (try
       (do
         (nop)
       )
       (catch $e-i32
         ;; This call is unreachable and can be removed. The pop, however, must
         ;; be carefully handled while we do so, to not break validation.
         (call $helper-i32-i32
           (pop i32)
           (br $label)
         )
         (nop)
       )
      )
    )
  )

  ;; CHECK:      (func $helper-i32-i32 (type $2) (param $0 i32) (param $1 i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $helper-i32-i32 (param $0 i32) (param $1 i32)
   (nop)
  )
)

