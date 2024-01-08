;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: wasm-opt %s --enable-multimemory --multi-memory-lowering --enable-bulk-memory --enable-extended-const --enable-simd --enable-threads -S -o - | filecheck %s
;; RUN: wasm-opt %s --enable-multimemory --multi-memory-lowering-with-bounds-checks --enable-bulk-memory --enable-extended-const --enable-simd --enable-threads -S -o - | filecheck %s --check-prefix BOUNDS

(module
  (memory $memory1 1)
  (memory $memory2 2)
  (memory $memory3 3)
  (data (memory $memory1) (i32.const 0) "a")
  (data (memory $memory3) (i32.const 1) "123")
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (param i32) (result v128)))

  ;; CHECK:      (type $2 (func (result i32)))

  ;; CHECK:      (type $3 (func (param i32) (result i32)))

  ;; CHECK:      (type $4 (func (param i32 v128) (result v128)))

  ;; CHECK:      (type $5 (func (param i32 i64)))

  ;; CHECK:      (global $memory2_byte_offset (mut i32) (i32.const 65536))

  ;; CHECK:      (global $memory3_byte_offset (mut i32) (i32.const 196608))

  ;; CHECK:      (memory $combined_memory 6)

  ;; CHECK:      (data $0 (i32.const 0) "a")

  ;; CHECK:      (data $1 (i32.const 196609) "123")

  ;; CHECK:      (func $loads
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load
  ;; CHECK-NEXT:    (i32.const 10)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (global.get $memory2_byte_offset)
  ;; CHECK-NEXT:     (i32.const 11)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (global.get $memory3_byte_offset)
  ;; CHECK-NEXT:     (i32.const 12)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (type $0 (func))

  ;; BOUNDS:      (type $1 (func (param i32) (result v128)))

  ;; BOUNDS:      (type $2 (func (result i32)))

  ;; BOUNDS:      (type $3 (func (param i32) (result i32)))

  ;; BOUNDS:      (type $4 (func (param i32 v128) (result v128)))

  ;; BOUNDS:      (type $5 (func (param i32 i64)))

  ;; BOUNDS:      (global $memory2_byte_offset (mut i32) (i32.const 65536))

  ;; BOUNDS:      (global $memory3_byte_offset (mut i32) (i32.const 196608))

  ;; BOUNDS:      (memory $combined_memory 6)

  ;; BOUNDS:      (data $0 (i32.const 0) "a")

  ;; BOUNDS:      (data $1 (i32.const 196609) "123")

  ;; BOUNDS:      (func $loads
  ;; BOUNDS-NEXT:  (local $0 i32)
  ;; BOUNDS-NEXT:  (local $1 i32)
  ;; BOUNDS-NEXT:  (local $2 i32)
  ;; BOUNDS-NEXT:  (drop
  ;; BOUNDS-NEXT:   (i32.load
  ;; BOUNDS-NEXT:    (block (result i32)
  ;; BOUNDS-NEXT:     (local.set $0
  ;; BOUNDS-NEXT:      (i32.const 10)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (if
  ;; BOUNDS-NEXT:      (i32.gt_u
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (i32.add
  ;; BOUNDS-NEXT:         (local.get $0)
  ;; BOUNDS-NEXT:         (i32.const 0)
  ;; BOUNDS-NEXT:        )
  ;; BOUNDS-NEXT:        (i32.const 4)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (call $memory1_size)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (then
  ;; BOUNDS-NEXT:       (unreachable)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (local.get $0)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT:  (drop
  ;; BOUNDS-NEXT:   (i32.load
  ;; BOUNDS-NEXT:    (block (result i32)
  ;; BOUNDS-NEXT:     (local.set $1
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (global.get $memory2_byte_offset)
  ;; BOUNDS-NEXT:       (i32.const 11)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (if
  ;; BOUNDS-NEXT:      (i32.gt_u
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (i32.add
  ;; BOUNDS-NEXT:         (local.get $1)
  ;; BOUNDS-NEXT:         (i32.const 0)
  ;; BOUNDS-NEXT:        )
  ;; BOUNDS-NEXT:        (i32.const 4)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (call $memory2_size)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (then
  ;; BOUNDS-NEXT:       (unreachable)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (local.get $1)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT:  (drop
  ;; BOUNDS-NEXT:   (i32.load
  ;; BOUNDS-NEXT:    (block (result i32)
  ;; BOUNDS-NEXT:     (local.set $2
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (global.get $memory3_byte_offset)
  ;; BOUNDS-NEXT:       (i32.const 12)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (if
  ;; BOUNDS-NEXT:      (i32.gt_u
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (i32.add
  ;; BOUNDS-NEXT:         (local.get $2)
  ;; BOUNDS-NEXT:         (i32.const 0)
  ;; BOUNDS-NEXT:        )
  ;; BOUNDS-NEXT:        (i32.const 4)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (call $memory3_size)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (then
  ;; BOUNDS-NEXT:       (unreachable)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (local.get $2)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $loads
  (drop
   (i32.load $memory1
    (i32.const 10)
   )
  )
  (drop
   (i32.load $memory2
    (i32.const 11)
   )
  )
  (drop
   (i32.load $memory3
    (i32.const 12)
   )
  )
  )
  ;; CHECK:      (func $stores
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:   (i32.const 115)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (global.get $memory2_byte_offset)
  ;; CHECK-NEXT:    (i32.const 11)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.const 115)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (global.get $memory3_byte_offset)
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.const 115)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (func $stores
  ;; BOUNDS-NEXT:  (local $0 i32)
  ;; BOUNDS-NEXT:  (local $1 i32)
  ;; BOUNDS-NEXT:  (local $2 i32)
  ;; BOUNDS-NEXT:  (i32.store
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $0
  ;; BOUNDS-NEXT:     (i32.const 10)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (local.get $0)
  ;; BOUNDS-NEXT:        (i32.const 0)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (i32.const 4)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory1_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $0)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:   (i32.const 115)
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT:  (i32.store
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $1
  ;; BOUNDS-NEXT:     (i32.add
  ;; BOUNDS-NEXT:      (global.get $memory2_byte_offset)
  ;; BOUNDS-NEXT:      (i32.const 11)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (local.get $1)
  ;; BOUNDS-NEXT:        (i32.const 0)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (i32.const 4)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory2_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $1)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:   (i32.const 115)
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT:  (i32.store
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $2
  ;; BOUNDS-NEXT:     (i32.add
  ;; BOUNDS-NEXT:      (global.get $memory3_byte_offset)
  ;; BOUNDS-NEXT:      (i32.const 12)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (local.get $2)
  ;; BOUNDS-NEXT:        (i32.const 0)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (i32.const 4)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory3_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $2)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:   (i32.const 115)
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $stores
  (i32.store $memory1
   (i32.const 10)
   (i32.const 115)
  )
  (i32.store $memory2
   (i32.const 11)
   (i32.const 115)
  )
  (i32.store $memory3
   (i32.const 12)
   (i32.const 115)
  )
  )

  ;; CHECK:      (func $v128.load8_splat (param $0 i32) (result v128)
  ;; CHECK-NEXT:  (v128.load8_splat
  ;; CHECK-NEXT:   (local.get $0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (func $v128.load8_splat (param $0 i32) (result v128)
  ;; BOUNDS-NEXT:  (local $1 i32)
  ;; BOUNDS-NEXT:  (v128.load8_splat
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $1
  ;; BOUNDS-NEXT:     (local.get $0)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (local.get $1)
  ;; BOUNDS-NEXT:        (i32.const 0)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (i32.const 1)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory1_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $1)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $v128.load8_splat (param $0 i32) (result v128)
  (v128.load8_splat $memory1
   (local.get $0)
  )
 )

  ;; CHECK:      (func $v128.load16_lane (param $0 i32) (param $1 v128) (result v128)
  ;; CHECK-NEXT:  (v128.load16_lane offset=32 align=1 0
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (global.get $memory2_byte_offset)
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.get $1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (func $v128.load16_lane (param $0 i32) (param $1 v128) (result v128)
  ;; BOUNDS-NEXT:  (local $2 i32)
  ;; BOUNDS-NEXT:  (v128.load16_lane offset=32 align=1 0
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $2
  ;; BOUNDS-NEXT:     (i32.add
  ;; BOUNDS-NEXT:      (global.get $memory2_byte_offset)
  ;; BOUNDS-NEXT:      (local.get $0)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (local.get $2)
  ;; BOUNDS-NEXT:        (i32.const 32)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (i32.const 2)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory2_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $2)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:   (local.get $1)
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $v128.load16_lane (param $0 i32) (param $1 v128) (result v128)
  (v128.load16_lane $memory2 offset=32 align=1 0
   (local.get $0)
   (local.get $1)
  )
 )

  ;; CHECK:      (func $v128.load32_zero (param $0 i32) (result v128)
  ;; CHECK-NEXT:  (v128.load32_zero offset=16 align=1
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (global.get $memory3_byte_offset)
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (func $v128.load32_zero (param $0 i32) (result v128)
  ;; BOUNDS-NEXT:  (local $1 i32)
  ;; BOUNDS-NEXT:  (v128.load32_zero offset=16 align=1
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $1
  ;; BOUNDS-NEXT:     (i32.add
  ;; BOUNDS-NEXT:      (global.get $memory3_byte_offset)
  ;; BOUNDS-NEXT:      (local.get $0)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (local.get $1)
  ;; BOUNDS-NEXT:        (i32.const 16)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (i32.const 4)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory3_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $1)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $v128.load32_zero (param $0 i32) (result v128)
  (v128.load32_zero $memory3 offset=16 align=1
   (local.get $0)
  )
 )
  ;; CHECK:      (func $v128.load32x2_s (param $0 i32) (result v128)
  ;; CHECK-NEXT:  (v128.load32x2_s
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (global.get $memory2_byte_offset)
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (func $v128.load32x2_s (param $0 i32) (result v128)
  ;; BOUNDS-NEXT:  (local $1 i32)
  ;; BOUNDS-NEXT:  (v128.load32x2_s
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $1
  ;; BOUNDS-NEXT:     (i32.add
  ;; BOUNDS-NEXT:      (global.get $memory2_byte_offset)
  ;; BOUNDS-NEXT:      (local.get $0)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (local.get $1)
  ;; BOUNDS-NEXT:        (i32.const 0)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (i32.const 8)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory2_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $1)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $v128.load32x2_s (param $0 i32) (result v128)
  (v128.load32x2_s $memory2
   (local.get $0)
  )
 )

  ;; CHECK:      (func $atomics (param $0 i32) (param $1 i64)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.atomic.rmw.add offset=4
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (global.get $memory3_byte_offset)
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i64.atomic.rmw32.cmpxchg_u offset=48
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (global.get $memory2_byte_offset)
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (memory.atomic.wait32 offset=16
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (memory.atomic.notify offset=24
  ;; CHECK-NEXT:    (i32.add
  ;; CHECK-NEXT:     (global.get $memory2_byte_offset)
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (func $atomics (param $0 i32) (param $1 i64)
  ;; BOUNDS-NEXT:  (local $2 i32)
  ;; BOUNDS-NEXT:  (local $3 i32)
  ;; BOUNDS-NEXT:  (local $4 i32)
  ;; BOUNDS-NEXT:  (local $5 i32)
  ;; BOUNDS-NEXT:  (drop
  ;; BOUNDS-NEXT:   (i32.atomic.rmw.add offset=4
  ;; BOUNDS-NEXT:    (block (result i32)
  ;; BOUNDS-NEXT:     (local.set $2
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (global.get $memory3_byte_offset)
  ;; BOUNDS-NEXT:       (local.get $0)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (if
  ;; BOUNDS-NEXT:      (i32.gt_u
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (i32.add
  ;; BOUNDS-NEXT:         (local.get $2)
  ;; BOUNDS-NEXT:         (i32.const 4)
  ;; BOUNDS-NEXT:        )
  ;; BOUNDS-NEXT:        (i32.const 4)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (call $memory3_size)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (then
  ;; BOUNDS-NEXT:       (unreachable)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (local.get $2)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $0)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT:  (drop
  ;; BOUNDS-NEXT:   (i64.atomic.rmw32.cmpxchg_u offset=48
  ;; BOUNDS-NEXT:    (block (result i32)
  ;; BOUNDS-NEXT:     (local.set $3
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (global.get $memory2_byte_offset)
  ;; BOUNDS-NEXT:       (local.get $0)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (if
  ;; BOUNDS-NEXT:      (i32.gt_u
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (i32.add
  ;; BOUNDS-NEXT:         (local.get $3)
  ;; BOUNDS-NEXT:         (i32.const 48)
  ;; BOUNDS-NEXT:        )
  ;; BOUNDS-NEXT:        (i32.const 4)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (call $memory2_size)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (then
  ;; BOUNDS-NEXT:       (unreachable)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (local.get $3)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $1)
  ;; BOUNDS-NEXT:    (local.get $1)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT:  (drop
  ;; BOUNDS-NEXT:   (memory.atomic.wait32 offset=16
  ;; BOUNDS-NEXT:    (block (result i32)
  ;; BOUNDS-NEXT:     (local.set $4
  ;; BOUNDS-NEXT:      (local.get $0)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (if
  ;; BOUNDS-NEXT:      (i32.gt_u
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (i32.add
  ;; BOUNDS-NEXT:         (local.get $4)
  ;; BOUNDS-NEXT:         (i32.const 16)
  ;; BOUNDS-NEXT:        )
  ;; BOUNDS-NEXT:        (i32.const 4)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (call $memory1_size)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (then
  ;; BOUNDS-NEXT:       (unreachable)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (local.get $4)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $0)
  ;; BOUNDS-NEXT:    (local.get $1)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT:  (drop
  ;; BOUNDS-NEXT:   (memory.atomic.notify offset=24
  ;; BOUNDS-NEXT:    (block (result i32)
  ;; BOUNDS-NEXT:     (local.set $5
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (global.get $memory2_byte_offset)
  ;; BOUNDS-NEXT:       (local.get $0)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (if
  ;; BOUNDS-NEXT:      (i32.gt_u
  ;; BOUNDS-NEXT:       (i32.add
  ;; BOUNDS-NEXT:        (i32.add
  ;; BOUNDS-NEXT:         (local.get $5)
  ;; BOUNDS-NEXT:         (i32.const 24)
  ;; BOUNDS-NEXT:        )
  ;; BOUNDS-NEXT:        (i32.const 4)
  ;; BOUNDS-NEXT:       )
  ;; BOUNDS-NEXT:       (call $memory2_size)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (then
  ;; BOUNDS-NEXT:       (unreachable)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (local.get $5)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $0)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $atomics (param $0 i32) (param $1 i64)
	(drop
   (i32.atomic.rmw.add $memory3 offset=4
    (local.get $0)
    (local.get $0)
   )
  )
(drop
   (i64.atomic.rmw32.cmpxchg_u $memory2 offset=48
    (local.get $0)
    (local.get $1)
    (local.get $1)
   )
  )
(drop
   (memory.atomic.wait32 $memory1 offset=16
    (local.get $0)
    (local.get $0)
    (local.get $1)
   )
  )
(drop
   (memory.atomic.notify $memory2 offset=24
    (local.get $0)
    (local.get $0)
   )
  )
  )

  ;; CHECK:      (func $memory.fill
  ;; CHECK-NEXT:  (memory.fill
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (func $memory.fill
  ;; BOUNDS-NEXT:  (local $0 i32)
  ;; BOUNDS-NEXT:  (local $1 i32)
  ;; BOUNDS-NEXT:  (local $2 i32)
  ;; BOUNDS-NEXT:  (memory.fill
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $2
  ;; BOUNDS-NEXT:     (i32.const 0)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.set $0
  ;; BOUNDS-NEXT:     (i32.const 1)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.set $1
  ;; BOUNDS-NEXT:     (i32.const 2)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (local.get $2)
  ;; BOUNDS-NEXT:       (local.get $1)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory1_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $2)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:   (local.get $0)
  ;; BOUNDS-NEXT:   (local.get $1)
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $memory.fill
    (memory.fill $memory1
      (i32.const 0)
      (i32.const 1)
      (i32.const 2)
    )
  )

  ;; CHECK:      (func $memory.copy
  ;; CHECK-NEXT:  (memory.copy
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (global.get $memory2_byte_offset)
  ;; CHECK-NEXT:    (i32.const 512)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (global.get $memory3_byte_offset)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.const 12)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (func $memory.copy
  ;; BOUNDS-NEXT:  (local $0 i32)
  ;; BOUNDS-NEXT:  (local $1 i32)
  ;; BOUNDS-NEXT:  (local $2 i32)
  ;; BOUNDS-NEXT:  (memory.copy
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $2
  ;; BOUNDS-NEXT:     (i32.add
  ;; BOUNDS-NEXT:      (global.get $memory2_byte_offset)
  ;; BOUNDS-NEXT:      (i32.const 512)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.set $0
  ;; BOUNDS-NEXT:     (i32.const 0)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.set $1
  ;; BOUNDS-NEXT:     (i32.const 12)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (local.get $2)
  ;; BOUNDS-NEXT:       (local.get $1)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory2_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $2)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (local.get $0)
  ;; BOUNDS-NEXT:       (local.get $1)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory3_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $0)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:   (local.get $1)
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $memory.copy
    (memory.copy $memory2 $memory3
      (i32.const 512)
      (i32.const 0)
      (i32.const 12)
    )
  )

  ;; CHECK:      (func $memory.init
  ;; CHECK-NEXT:  (memory.init $0
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (global.get $memory2_byte_offset)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (i32.const 45)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  ;; BOUNDS:      (func $memory.init
  ;; BOUNDS-NEXT:  (local $0 i32)
  ;; BOUNDS-NEXT:  (local $1 i32)
  ;; BOUNDS-NEXT:  (local $2 i32)
  ;; BOUNDS-NEXT:  (memory.init $0
  ;; BOUNDS-NEXT:   (block (result i32)
  ;; BOUNDS-NEXT:    (local.set $2
  ;; BOUNDS-NEXT:     (i32.add
  ;; BOUNDS-NEXT:      (global.get $memory2_byte_offset)
  ;; BOUNDS-NEXT:      (i32.const 0)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.set $0
  ;; BOUNDS-NEXT:     (i32.const 1)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.set $1
  ;; BOUNDS-NEXT:     (i32.const 45)
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (local.get $2)
  ;; BOUNDS-NEXT:       (local.get $1)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (call $memory2_size)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (if
  ;; BOUNDS-NEXT:     (i32.gt_u
  ;; BOUNDS-NEXT:      (i32.add
  ;; BOUNDS-NEXT:       (local.get $0)
  ;; BOUNDS-NEXT:       (local.get $1)
  ;; BOUNDS-NEXT:      )
  ;; BOUNDS-NEXT:      (i32.const 1)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:     (then
  ;; BOUNDS-NEXT:      (unreachable)
  ;; BOUNDS-NEXT:     )
  ;; BOUNDS-NEXT:    )
  ;; BOUNDS-NEXT:    (local.get $2)
  ;; BOUNDS-NEXT:   )
  ;; BOUNDS-NEXT:   (local.get $0)
  ;; BOUNDS-NEXT:   (local.get $1)
  ;; BOUNDS-NEXT:  )
  ;; BOUNDS-NEXT: )
  (func $memory.init
    (memory.init $memory2 0
      (i32.const 0)
      (i32.const 1)
      (i32.const 45)
    )
  )
)

;; CHECK:      (func $memory1_size (result i32)
;; CHECK-NEXT:  (return
;; CHECK-NEXT:   (i32.div_u
;; CHECK-NEXT:    (global.get $memory2_byte_offset)
;; CHECK-NEXT:    (i32.const 65536)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $memory2_size (result i32)
;; CHECK-NEXT:  (return
;; CHECK-NEXT:   (i32.sub
;; CHECK-NEXT:    (i32.div_u
;; CHECK-NEXT:     (global.get $memory3_byte_offset)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.div_u
;; CHECK-NEXT:     (global.get $memory2_byte_offset)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $memory3_size (result i32)
;; CHECK-NEXT:  (return
;; CHECK-NEXT:   (i32.sub
;; CHECK-NEXT:    (memory.size)
;; CHECK-NEXT:    (i32.div_u
;; CHECK-NEXT:     (global.get $memory3_byte_offset)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $memory1_grow (param $page_delta i32) (result i32)
;; CHECK-NEXT:  (local $return_size i32)
;; CHECK-NEXT:  (local $memory_size i32)
;; CHECK-NEXT:  (local.set $return_size
;; CHECK-NEXT:   (call $memory1_size)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.set $memory_size
;; CHECK-NEXT:   (memory.size)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.eq
;; CHECK-NEXT:    (memory.grow
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.const -1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (then
;; CHECK-NEXT:    (return
;; CHECK-NEXT:     (i32.const -1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (memory.copy
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $memory2_byte_offset)
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (global.get $memory2_byte_offset)
;; CHECK-NEXT:   (i32.sub
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $memory_size)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (global.get $memory2_byte_offset)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (global.set $memory2_byte_offset
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $memory2_byte_offset)
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (global.set $memory3_byte_offset
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $memory3_byte_offset)
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.get $return_size)
;; CHECK-NEXT: )

;; CHECK:      (func $memory2_grow (param $page_delta i32) (result i32)
;; CHECK-NEXT:  (local $return_size i32)
;; CHECK-NEXT:  (local $memory_size i32)
;; CHECK-NEXT:  (local.set $return_size
;; CHECK-NEXT:   (call $memory2_size)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.set $memory_size
;; CHECK-NEXT:   (memory.size)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.eq
;; CHECK-NEXT:    (memory.grow
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.const -1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (then
;; CHECK-NEXT:    (return
;; CHECK-NEXT:     (i32.const -1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (memory.copy
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $memory3_byte_offset)
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (global.get $memory3_byte_offset)
;; CHECK-NEXT:   (i32.sub
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $memory_size)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (global.get $memory3_byte_offset)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (global.set $memory3_byte_offset
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (global.get $memory3_byte_offset)
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.get $return_size)
;; CHECK-NEXT: )

;; CHECK:      (func $memory3_grow (param $page_delta i32) (result i32)
;; CHECK-NEXT:  (local $return_size i32)
;; CHECK-NEXT:  (local.set $return_size
;; CHECK-NEXT:   (call $memory3_size)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.eq
;; CHECK-NEXT:    (memory.grow
;; CHECK-NEXT:     (local.get $page_delta)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.const -1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (then
;; CHECK-NEXT:    (return
;; CHECK-NEXT:     (i32.const -1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.get $return_size)
;; CHECK-NEXT: )

;; BOUNDS:      (func $memory1_size (result i32)
;; BOUNDS-NEXT:  (return
;; BOUNDS-NEXT:   (i32.div_u
;; BOUNDS-NEXT:    (global.get $memory2_byte_offset)
;; BOUNDS-NEXT:    (i32.const 65536)
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT: )

;; BOUNDS:      (func $memory2_size (result i32)
;; BOUNDS-NEXT:  (return
;; BOUNDS-NEXT:   (i32.sub
;; BOUNDS-NEXT:    (i32.div_u
;; BOUNDS-NEXT:     (global.get $memory3_byte_offset)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:    (i32.div_u
;; BOUNDS-NEXT:     (global.get $memory2_byte_offset)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT: )

;; BOUNDS:      (func $memory3_size (result i32)
;; BOUNDS-NEXT:  (return
;; BOUNDS-NEXT:   (i32.sub
;; BOUNDS-NEXT:    (memory.size)
;; BOUNDS-NEXT:    (i32.div_u
;; BOUNDS-NEXT:     (global.get $memory3_byte_offset)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT: )

;; BOUNDS:      (func $memory1_grow (param $page_delta i32) (result i32)
;; BOUNDS-NEXT:  (local $return_size i32)
;; BOUNDS-NEXT:  (local $memory_size i32)
;; BOUNDS-NEXT:  (local.set $return_size
;; BOUNDS-NEXT:   (call $memory1_size)
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (local.set $memory_size
;; BOUNDS-NEXT:   (memory.size)
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (if
;; BOUNDS-NEXT:   (i32.eq
;; BOUNDS-NEXT:    (memory.grow
;; BOUNDS-NEXT:     (local.get $page_delta)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:    (i32.const -1)
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:   (then
;; BOUNDS-NEXT:    (return
;; BOUNDS-NEXT:     (i32.const -1)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (memory.copy
;; BOUNDS-NEXT:   (i32.add
;; BOUNDS-NEXT:    (global.get $memory2_byte_offset)
;; BOUNDS-NEXT:    (i32.mul
;; BOUNDS-NEXT:     (local.get $page_delta)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:   (global.get $memory2_byte_offset)
;; BOUNDS-NEXT:   (i32.sub
;; BOUNDS-NEXT:    (i32.mul
;; BOUNDS-NEXT:     (local.get $memory_size)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:    (global.get $memory2_byte_offset)
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (global.set $memory2_byte_offset
;; BOUNDS-NEXT:   (i32.add
;; BOUNDS-NEXT:    (global.get $memory2_byte_offset)
;; BOUNDS-NEXT:    (i32.mul
;; BOUNDS-NEXT:     (local.get $page_delta)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (global.set $memory3_byte_offset
;; BOUNDS-NEXT:   (i32.add
;; BOUNDS-NEXT:    (global.get $memory3_byte_offset)
;; BOUNDS-NEXT:    (i32.mul
;; BOUNDS-NEXT:     (local.get $page_delta)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (local.get $return_size)
;; BOUNDS-NEXT: )

;; BOUNDS:      (func $memory2_grow (param $page_delta i32) (result i32)
;; BOUNDS-NEXT:  (local $return_size i32)
;; BOUNDS-NEXT:  (local $memory_size i32)
;; BOUNDS-NEXT:  (local.set $return_size
;; BOUNDS-NEXT:   (call $memory2_size)
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (local.set $memory_size
;; BOUNDS-NEXT:   (memory.size)
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (if
;; BOUNDS-NEXT:   (i32.eq
;; BOUNDS-NEXT:    (memory.grow
;; BOUNDS-NEXT:     (local.get $page_delta)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:    (i32.const -1)
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:   (then
;; BOUNDS-NEXT:    (return
;; BOUNDS-NEXT:     (i32.const -1)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (memory.copy
;; BOUNDS-NEXT:   (i32.add
;; BOUNDS-NEXT:    (global.get $memory3_byte_offset)
;; BOUNDS-NEXT:    (i32.mul
;; BOUNDS-NEXT:     (local.get $page_delta)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:   (global.get $memory3_byte_offset)
;; BOUNDS-NEXT:   (i32.sub
;; BOUNDS-NEXT:    (i32.mul
;; BOUNDS-NEXT:     (local.get $memory_size)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:    (global.get $memory3_byte_offset)
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (global.set $memory3_byte_offset
;; BOUNDS-NEXT:   (i32.add
;; BOUNDS-NEXT:    (global.get $memory3_byte_offset)
;; BOUNDS-NEXT:    (i32.mul
;; BOUNDS-NEXT:     (local.get $page_delta)
;; BOUNDS-NEXT:     (i32.const 65536)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (local.get $return_size)
;; BOUNDS-NEXT: )

;; BOUNDS:      (func $memory3_grow (param $page_delta i32) (result i32)
;; BOUNDS-NEXT:  (local $return_size i32)
;; BOUNDS-NEXT:  (local.set $return_size
;; BOUNDS-NEXT:   (call $memory3_size)
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (if
;; BOUNDS-NEXT:   (i32.eq
;; BOUNDS-NEXT:    (memory.grow
;; BOUNDS-NEXT:     (local.get $page_delta)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:    (i32.const -1)
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:   (then
;; BOUNDS-NEXT:    (return
;; BOUNDS-NEXT:     (i32.const -1)
;; BOUNDS-NEXT:    )
;; BOUNDS-NEXT:   )
;; BOUNDS-NEXT:  )
;; BOUNDS-NEXT:  (local.get $return_size)
;; BOUNDS-NEXT: )
