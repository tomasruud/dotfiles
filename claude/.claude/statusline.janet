(import spork/json)

(defn usage-emoji [used]
  (cond
    (> 10 used) "😄👍"
    (> 20 used) "😊🤙"
    (> 30 used) "😎🤌"
    (> 40 used) "😐🤏"
    (> 50 used) "😑✋"
    (> 60 used) "😕👎"
    (> 70 used) "😟🤞"
    (> 80 used) "😦🤚"
    (> 90 used) "😧✊"
    "🥵🤚"))

(defn limit-emoji [used]
  (cond
    (> 50 used) "😎"
    (> 60 used) "😎🤏"
    (> 75 used) "😳🕶🤏"
    (> 90 used) "🫣"
    "😵"))

(defn render [data]
  (def model-name (get-in data ["model" "display_name"] "-"))
  (def used-ctx (get-in data ["context_window" "used_percentage"] nil))
  (def limit-5-hour (get-in data ["rate_limits" "five_hour" "used_percentage"] nil))
  (def limit-7-day (get-in data ["rate_limits" "seven_day" "used_percentage"] nil))

  (prin "🧠" model-name)

  (unless (nil? used-ctx)
    (prin " " (usage-emoji used-ctx)))

  (unless (nil? limit-5-hour)
    (prin " " (limit-emoji limit-5-hour)))

  (print))

(defn main [& args]
  (->>
    (file/read stdin :all)
    json/decode
    render))
