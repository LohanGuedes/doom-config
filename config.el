;;; config.el -*- lexical-binding: t; -*-
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "lguedes"
      user-mail-address "lguedes@student.42.rio")

;; Better Defaults
(setq-default
 delete-by-moving-to-trash t                         ; Delete files to trash
 window-combination-resize t                         ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                                 ; Stretch cursor to the glyph width
(setq undo-limit 80000000                            ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                          ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                            ; Nobody likes to loose work, I certainly don't
truncate-string-ellipsis "…"                  ; Unicode ellispis are nicer than "...", and also save /precious/ space
password-cache-expiry nil                      ; I can trust my computers ... can't I?
scroll-margin 7)
(display-time-mode 1)                                ; Show current time on modeline
;; (unless (string-match-p "^Power N/A" (battery))   ; On laptops... For knowing how much power left
;;   (display-battery-mode 1))
(global-subword-mode 1)                              ; Iterate Through CammelCase
;; Setting Fonts like a chad:
(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 14)
doom-big-font (font-spec :family "Iosevka Nerd Font" :size 16)
doom-variable-pitch-font (font-spec :family "Overpass Nerd Font" :size 14)
doom-unicode-font (font-spec :family "JuliaMono")
doom-serif-font (font-spec :family "BlexMono Nerd Font" :weight 'light))

;; Setting theme + Changing the default collor on the modeline (for better)
(setq doom-theme 'doom-gruvbox)
(remove-hook 'window-setup-hook #'doom-init-theme-h)
(add-hook 'after-init-hook #'doom-init-theme-h 'append)
(delq! t custom-theme-load-path)

(custom-set-faces!
'(doom-modeline-buffer-modified :foreground "orange"))

;; Treemacs with actual icons.
(setq doom-themes-treemacs-theme "doom-colors")

;; Line numbers (I do not relative most of the time but I might change this later on)
;; You can toggle this on & off by doing SPC - t - l
(setq display-line-numbers-type 't)

;; Prompt for which buffer to open on a window.
(setq evil-vsplit-window-right t
evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
:after '(evil-window-split evil-window-vsplit)
(consult-buffer))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Norminette better Defaults ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Better Showing of whitespaces so I don't forget them at the end of the line or in a blank line ( norminette fuck you. )
(global-whitespace-mode)
(setq whitespace-style '(face tabs tab-mark trailing))
(custom-set-faces
'(whitespace-tab ((t (:foreground "#636363")))))
(setq whitespace-display-mappings
'((tab-mark 9 [124 9] [92 9])))

;; Tabs for C... again, FUCK NORMINETTE!
(setq custom-tab-width 4)
(defun disable-tabs () (setq indent-tabs-mode nil))
(defun enable-tabs  () ; I Guess this would be a function which I should find on my M-x right?
(local-set-key (kbd "TAB") 'tab-to-tab-stop)
(setq indent-tabs-mode t)
(setq tab-width custom-tab-width))
;; Hooks to Enable Tabs
(add-hook 'c-mode-hook 'enable-tabs)

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; ORG MODE ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Setting org, org-agenda, org-roam directories
(setq org-directory "~/MyOrg")
(after! org-roam
(setq org-roam-directory "~/MyOrg/Roam/"))


(after! org
(after! org-superstar
(setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        org-superstar-prettify-item-bullets t ))

(setq org-ellipsis " ▾ "
org-hide-leading-stars t
org-priority-highest ?A
org-priority-lowest ?E
org-priority-faces
'((?A . 'all-the-icons-red)
        (?B . 'all-the-icons-orange)
        (?C . 'all-the-icons-yellow)
        (?D . 'all-the-icons-green)
        (?E . 'all-the-icons-blue)))
(appendq! +ligatures-extra-symbols
        `(:checkbox      "☐"
        :pending       "◼"
        :checkedbox    "☑"
        :list_property "∷"
        :em_dash       "—"
        :ellipses      "…"
        :arrow_right   "→"
        :arrow_left    "←"
        :title         "𝙏"
        :subtitle      "𝙩"
        :author        "𝘼"
        :date          "𝘿"
        :property      "☸"
        :options       "⌥"
        :startup       "⏻"
        :macro         "𝓜"
        :html_head     "🅷"
        :html          "🅗"
        :latex_class   "🄻"
        :latex_header  "🅻"
        :beamer_header "🅑"
        :latex         "🅛"
        :attr_latex    "🄛"
        :attr_html     "🄗"
        :attr_org      "⒪"
        :begin_quote   "❝"
        :end_quote     "❞"
        :caption       "☰"
        :header        "›"
        :results       "🠶"
        :begin_export  "⏩"
        :end_export    "⏪"
        :properties    "⚙"
        :end           "∎"
        :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
        :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
        :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
        :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
        :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)))
(set-ligatures! 'org-mode
:merge t
:checkbox      "[ ]"
:pending       "[-]"
:checkedbox    "[X]"
:list_property "::"
:em_dash       "---"
:ellipsis      "..."
:arrow_right   "->"
:arrow_left    "<-"
:title         "#+title:"
:subtitle      "#+subtitle:"
:author        "#+author:"
:date          "#+date:"
:property      "#+property:"
:options       "#+options:"
:startup       "#+startup:"
:macro         "#+macro:"
:html_head     "#+html_head:"
:html          "#+html:"
:latex_class   "#+latex_class:"
:latex_header  "#+latex_header:"
:beamer_header "#+beamer_header:"
:latex         "#+latex:"
:attr_latex    "#+attr_latex:"
:attr_html     "#+attr_html:"
:attr_org      "#+attr_org:"
:begin_quote   "#+begin_quote"
:end_quote     "#+end_quote"
:caption       "#+caption:"
:header        "#+header:"
:begin_export  "#+begin_export"
:end_export    "#+end_export"
:results       "#+RESULTS:"
:property      ":PROPERTIES:"
:end           ":END:"
:priority_a    "[#A]"
:priority_b    "[#B]"
:priority_c    "[#C]"
:priority_d    "[#D]"
:priority_e    "[#E]")
(plist-put +ligatures-extra-symbols :name "⁍")

;; Font Display  - Mixed pitch
(add-hook 'org-mode-hook #'+org-pretty-mode)
(custom-set-faces!
        '(outline-1 :weight extra-bold :height 1.25)
        '(outline-2 :weight bold :height 1.20)
        '(outline-3 :weight bold :height 1.12)
        '(outline-4 :weight semi-bold :height 1.09)
        '(outline-5 :weight semi-bold :height 1.06)
        '(outline-6 :weight semi-bold :height 1.03)
        '(outline-8 :weight semi-bold)
        '(outline-9 :weight semi-bold))
(custom-set-faces!
        '(org-document-title :height 1.2)))

;; Templates for Org-Roam Capture, Take better notes with roam!
(setq org-roam-capture-templates
'(("d" "Default" plain
"%?"
:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
:unnarrowed t)
("l" "Programming Language" plain
"* Characteristics\n\n- Family: %?\n- Inspired by: \n\n* Reference:\n\n"
:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
:unnarrowed t)
("b" "book notes" plain
"\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n* Summary\n\n%?"
:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
:unnarrowed t)
("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project")
:unnarrowed t)))

;; Rust things
;; probably shit.
(setq lsp-rust-server 'rust-analyzer)
(after! rustic
(setq lsp-rust-server 'rust-analyzer))


;; Testing things for my C
(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                "--clang-tidy"
                "--completion-style=detailed"
                "--header-insertion=never"
                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))
