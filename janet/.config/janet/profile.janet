(setdyn :doc-color false)

(defn find-doc [needle]
  (def n (string/ascii-lower needle))
  (def matches @[])
  (each sym (all-bindings)
    (def entry (dyn sym))
    (def hay (string/ascii-lower
               (string sym " " (or (get entry :doc) ""))))
    (when (string/find n hay)
      (array/push matches sym)))
  (sort matches)
  (each sym matches
    (print "── " sym " ──")
    (when-let [d (get (dyn sym) :doc)]
      (print d))
    (print))
  (printf "%d matches." (length matches)))

(print "profile loaded")
