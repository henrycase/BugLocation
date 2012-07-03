(ns BugLocation.core
  (:gen-class))

(def bug-dev "192.168.2.63")
(defonce bug-host bug-dev)           ; normally 127.0.0.1

(defn getLocation
  "Poll the bug's location service."
  []
  (let [location (slurp (format "http://%s/service/Location" bug-host))]
    location))


(defn -main [& args]
  (println "[+] polling...")
  (while true
    (Thread/sleep 1000)
    (println (getLocation))))
