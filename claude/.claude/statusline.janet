(import spork/json)

(defn render [data]
  (as->
    [(when-let [model (get-in data ["model" "display_name"])]
       (string "🧠" model))

     (when-let [used (get-in data ["context_window" "used_percentage"])
                emoji (cond
                        (< used 10) "😄👍"
                        (< used 20) "😊🤙"
                        (< used 30) "😎🤌"
                        (< used 40) "😐🤏"
                        (< used 50) "😑✋"
                        (< used 60) "😕👎"
                        (< used 70) "😟🤞"
                        (< used 80) "😦🤚"
                        (< used 90) "😧✊"
                        "🥵🤚")]
       (string "[" used "%]-" emoji))

     (when-let [used (get-in data ["rate_limits" "five_hour" "used_percentage"])
                emoji (cond
                        (< used 50) nil
                        (< used 60) "😎"
                        (< used 70) "😎🤏"
                        (< used 80) "😳🕶🤏"
                        (< used 90) "🫣"
                        "😵")]
       (string "[" used "%]-" emoji))

     (when-let [used (get-in data ["rate_limits" "seven_day" "used_percentage"])
                _ (> used 90)]
       "💀")] _

    (filter identity _)
    (string/join _ " ")))

(defn main [& args]
  (->
    (file/read stdin :all)
    (json/decode false true)
    render
    print))
