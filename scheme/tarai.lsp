( defun tarai ( x y z )
  ( if ( <= x y )
    y
    ( taray (tarai ( - x 1 ) y z )
      ( tarai ( - y 1 ) z x )
      ( tarai (- z1) x y ))))
        )))
