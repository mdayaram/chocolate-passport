# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js"

# For Chocolate tables
pin "datatables.net-dt", to: "https://ga.jspm.io/npm:datatables.net-dt@2.0.8/js/dataTables.dataTables.mjs", preload: false
pin "datatables.net", to: "https://ga.jspm.io/npm:datatables.net@2.0.8/js/dataTables.mjs", preload: false
pin "lazyload", to: "https://ga.jspm.io/npm:lazyload@2.0.0-rc.2/lazyload.js", preload: false
