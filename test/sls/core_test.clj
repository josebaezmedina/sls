(ns sls.core-test
  (:require [clojure.test :refer :all]
            [sls.core :refer :all]
            [clojure.java.io :as io]))

(def test-folder-path "~/test_folder")

(deftest test-format-name
  (testing "should add quotes to name"
    (is (= "'test name'" (format-name "test name")))))

(deftest should-strip-flags
  (testing "should strip flagas from arguments leaving only path")
  (def args #{"/" "-t" "-a"})
  (is (= "/" (strip-flags args))))

(deftest should-get-files
  (testing "should get files per path with hidden"
    (is (not= nil (get-files-per-path test-folder-path true))))
  (testing "should get files per path without hidden"
    (is (not= nil (get-files-per-path test-folder-path false)))))

(deftest should-get-info-populated
  (testing "should get info populated per file"
    (def file-test (io/file test-folder-path))
    (def file-infos  (populate-info  file-test))
    ;; (println file-infos)
    (is (not= nil file-infos))))

(deftest should-get-a-table
  (testing "should get a file list as a table"
  ;; (println (get-files-per-path "." true))
    (is (not= nil (with-out-str (show-as-table (get-files-per-path test-folder-path true)))))))

(deftest should-get-a-list
  (testing "test if a list is generated"
    (def res (with-out-str (print-all ["."])))
    (is (not= nil res))))