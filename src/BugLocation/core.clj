(ns BugLocation.core
  (:gen-class)
  (:use [clojure.xml :only (parse)]))

(def bug-host (ref "127.0.0.1"))

(defn hasLocationService?
  []
  (let [services-xml (:content (parse (format "http://%s/service" @bug-host)))]
    (< 0 (count
          (filter #(= (:name %) "Location")
                  (map :attrs
                       (filter #(= (:tag %) :service) services-xml)))))))

(defn getLocation
  "Poll the bug's location service."
  []
  (let [location-xml (parse (format "http://%s/service/Location" @bug-host))]
    (doall (:content location-xml))))


(defn -main [& args]
  (if (> (count args) 0)
    (dosync (ref-set bug-host (first args))))
  (println "[+] checking for location service...")
  (if (hasLocationService?)
    (do
      (println "[+] location service found.")
      (println "[+] polling...")
      (while true
        (Thread/sleep 1000)
        (let [location (getLocation)]
          (if-not (nil? location)
            (println location)
            (println "[!] no fix!")))))
    (println "[!] location service not found!")))
