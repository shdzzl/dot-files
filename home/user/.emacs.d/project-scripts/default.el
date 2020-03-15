;; Load local elisp scripts
(dolist (module '("use-package.el"
                  "lisp.el"
                  "sql.el"
                  "markdown.el"
                  "web.el"
                  "eglot.el"
                  "clojure.el"
                  "haskell.el"
                  "rust.el"
                  "python.el"
                  "dart.el"
                  "scala.el"
                  "nim.el"
                  "cpp.el"))
  (load (expand-file-name (concat "~/.emacs.d/local-scripts/" module))))
