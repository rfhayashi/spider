(ns index-test
  (:require [index :refer [sum]]))

(js/test
 "adds 1 + 2 to be equal to 3"
 (fn [] (.toBe (js/expect (sum 1 2)) 3)))
