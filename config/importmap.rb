# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin '@line/liff', to: 'https://static.line-scdn.net/liff/edge/2/sdk.js'
pin_all_from "app/javascript/controllers", under: "controllers"
