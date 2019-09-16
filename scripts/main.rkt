#lang racket

(require xml)

(module+ test
  (require rackunit))

(define www "../")

;; create-page :: [Listof XExpr] String -> Void
;; Creates an html page from given xepression and name.
(define/contract (write-page xexprs page-name)
  (-> (listof xexpr/c) string? void?)
  (with-output-to-file (string-append www page-name ".html")
    #:exists 'replace
    (λ ()
      (displayln "<!DOCTYPE html>")
      (for-each (lambda (x) (write-xexpr x #:insert-newlines? #t)) xexprs))))

;; make-page :: XExpr String -> [Listof XExpr]
;; Adds Header/Footer to an XExpr(the web page)
(define/contract (make-page xexpr name)
  (-> xexpr/c string? (listof xexpr/c))
  `((head
     (title ,(string-append name " - Ivan Quiles-Rodriguez"))
     (meta ((charset "utf-8")))
     (link ((rel "stylesheet")
            (href "stylesheet.css"))))
    (body
     (div ((class "left")) (p " "))
     (div ((class "middle")) ,header ,xexpr)
     (div ((class "right"))))))

;; Defines the XExpr for header for each page
(define header
  `(div ((class "menu"))
        (center (h1 "Ivan Quiles-Rodriguez")
        (ul
         (li (a ((href "index.html")) "Home"))
         (li (a ((href "resume.pdf")) "Resume"))))
        (hr)))

;; Home Content
(define home-content
  `(div ((class "home-page"))
        (p "Hi! 👋🏾, I'm Ivan Quiles-Rodriguez and I'm currently a senior at "
          (a ((href "https://umd.edu/" )) "University of Maryland, College Park")
          " studying Computer Science and Mathematics."
          " Very recently, I have started working on the Checked C project at "
          (a ((href "https://www.cs.umd.edu/projects/PL/")) "PLUM!")
          " At my University I am currently a Teaching Assistant for the "
          (a ((href "https://www.cs.umd.edu/class/fall2019/cmsc430/"))
             "Introduction to Compilers")
          " course and I was previously a teaching assistant for: ")
       (ul
        (li (a ((href "https://www.cs.umd.edu/class/spring2019/cmsc216/"))
               "CMSC216: Introduction to Computer Systems"))
        (li (a ((href "https://www.cs.umd.edu/class/fall2018/cmsc132/"))
               "CMSC132: Object Oriented Programming II"))
        (li (a ((href "https://www.cs.umd.edu/class/spring2018/cmsc216/"))
               "CMSC216: Introduction to Computer Systems")))
       (p "Outside of school I have interned at "
          (a ((href "https://about.twitter.com/")) "Twitter")
          " where I worked on "
          (a ((href "https://twitter.com/Twitter/status/1055202622888538113"))
             "Frequently Used GIFs")
          " for the Android mobile app. I've also interned at "
          (a ((href "https://www.microsoft.com/en-us/")) "Microsoft")
          " where I worked on the Cortana Core team and prototyped"
          " a feature for deeper integrations between Third Party Skills"
          " built in Bot Framework and first-party Cortana Skills.")
       (p "Note: This page is still under construction!")))

; Script where pages are actually created
(write-page (make-page home-content "Home") "index")

;; Tests!
(module+ test
  (check-equal? (xexpr? header) #t)
  (check-equal? (xexpr? home-content) #t))
