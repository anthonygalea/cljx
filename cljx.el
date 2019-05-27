;;; cljx.el --- cljx support -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Anthony Galea

;; Author: Anthony Galea <anthony.galea@gmail.com>
;; URL: http://github.com/anthonygalea/cljx/
;; Keywords: clojure, cljx
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Quick start:
;;   open a cljx file
;;   run (cljx-upgrade)

;;; Code:

(defun cljx-upgrade ()
  "Upgrades the contents of the current buffer to use reader conditionals."
  (interactive)
  (cl-flet ((upgrade (platform)
              (goto-char (point-min))
              (let ((rgx (concat "#\\+" platform "\\b")))
                (while (re-search-forward rgx nil t)
                  (let ((type-hint? (looking-at-p " +\\^")))
                    (if type-hint?
                      (progn
                        (replace-match (concat "#?@(:" platform " ("))
                        (forward-sexp)
                        (forward-sexp)
                        (insert "))"))
                      (progn
                        (replace-match (concat "#?(:" platform))
                        (forward-sexp)
                        (insert ")"))))))))
    (save-excursion
      (upgrade "clj")
      (upgrade "cljs"))))

(provide 'cljx)
;;; cljx.el ends here

