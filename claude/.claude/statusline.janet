(import spork/json)

(defn usage-emoji [used]
  (cond
    (< used 10) "😄👍"
    (< used 20) "😊🤙"
    (< used 30) "😎🤌"
    (< used 40) "😐🤏"
    (< used 50) "😑✋"
    (< used 60) "😕👎"
    (< used 70) "😟🤞"
    (< used 80) "😦🤚"
    (< used 90) "😧✊"
    "🥵🤚"))

(defn limit-emoji [used]
  (cond
    (< used 50) "😎"
    (< used 60) "😎🤏"
    (< used 75) "😳🕶🤏"
    (< used 90) "🫣"
    "😵"))

(defn render [data]
  (def model-name (get-in data ["model" "display_name"] "-"))
  (def used-ctx (get-in data ["context_window" "used_percentage"]))
  (def limit-5-hour (get-in data ["rate_limits" "five_hour" "used_percentage"]))
  (def limit-7-day (get-in data ["rate_limits" "seven_day" "used_percentage"]))

  (prin "🧠" model-name)

  (unless (nil? used-ctx)
    (prin " " (usage-emoji used-ctx)))

  (unless (nil? limit-5-hour)
    (prin " " (limit-emoji limit-5-hour)))

  (when (> limit-7-day 90)
    (prin " 💀"))

  (print))

(defn main [& args]
  (->>
    (file/read stdin :all)
    json/decode
    render))
