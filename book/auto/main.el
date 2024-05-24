(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("report" "11pt" "a4paper")))
   (TeX-run-style-hooks
    "latex2e"
    "ch01"
    "ch07"
    "report"
    "rep11"
    "color"
    "graphicx"
    "subcaption"))
 :latex)

