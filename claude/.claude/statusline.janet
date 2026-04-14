(import spork/json)

(defn model-name [data]
  (get-in data ["model" "display_name"] "-"))

(defn ctx-usage [data]
  (math/round
    (get-in data ["context_window" "used_percentage"] 0)))

(defn render [data]
  (string
    (model-name data) " - "
    (ctx-usage data) "% used"))

(defn main [& args]
  (->>
    (file/read stdin :all)
    json/decode
    render
    print))
