(ns sls.core
  (:require [clojure.java.io :as io]
            [clojure.pprint :as pp]
            [clj-commons.humanize :as ch]
            [clojure.term.colors :as tc]
            [clojure.string :as cs]
            [table.core :as tbl])
  (:gen-class))

(defn format-name [name]
  (if (cs/includes? name " ") (str "'" name "'") (identity name)))

(defn populate-info [file]
  {:is-file (.isFile file)
   :is-directory (.isDirectory file)
   :is-hidden (.isHidden file)
   :name  (format-name (cs/replace-first (.toString file) (str (.getParent file) "/") ""))
   :size  (ch/filesize (.length file) :binary false)
   :parent-name (.getParent file)})

(defn get-files-per-path [path show-hidden?]
  (cond->> path
    true (io/file)
    true (.listFiles)
    true (map populate-info)
    true (sort-by :name)
    (not show-hidden?) (filter #(not= (:is-hidden %) true))))

(defn show-as-table [file-g]
  (tbl/table file-g :fields [:name :size :is-file :is-directory :parent-name] :desc true :sort true))

(defn format-directory [file-g]
  (tc/blue (str "[" (:name file-g) "] ")))

(defn format-file [file-g]
  ((if (:is-hidden file-g) tc/grey tc/white) (str "[" (:name file-g) " " (:size file-g) "] ")))

(defn print-beautified [file-g]
  (if (:is-file file-g) (format-file file-g) (format-directory file-g)))

(defn show-as-list [files]
  (apply println (map print-beautified files)))

(defn strip-flags [args-set]
  (first (disj (disj args-set "-t") "-a")))



(defn print-all [argsx]
  (def args-set (into #{} argsx))
  (def show-hidden (if (some #(cs/includes? % "-a") argsx)  true false))
  (def show-as-table? (if (some #(cs/includes? % "-t") argsx)  true false))
  (def rest-args (strip-flags args-set))
  (def path (if (nil? rest-args) "." rest-args))

  (def files-to-print (get-files-per-path path show-hidden))

  (if show-as-table?
    (show-as-table files-to-print)
    (show-as-list files-to-print)))



(defn -main
  "slow ls command alternative"
  [& args]
  (print-all args)

  (System/exit 0))