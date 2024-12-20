(defproject sls "0.0.1"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies [[org.clojure/clojure "1.11.1"]
                 [org.clj-commons/humanize "1.1"]
                 [clojure-term-colors "0.1.0"]
                 [rm-hull/table "0.7.1"]
                 ]
  :main ^:skip-aot sls.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all
                       :jvm-opts ["-Dclojure.compiler.direct-linking=true"]}}
  :plugins [[lein-cloverage "1.2.4"]])
