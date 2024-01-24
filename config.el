;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;;=============================================================================
;;                          My config.el Start Here
;;=============================================================================

;;; org

;; org capture
;;(setq +org-capture-notes-file "roam/Slipbox.org"
;;      +org-capture-todo-file "roam/Slipbox.org"
;;      +org-capture-journal-file "roam/main/bujo.org")
(after! org
  (setq org-capture-templates
        '(("t" "Personal (t)odo" entry
           (file+headline "roam/Slipbox.org" "TODOs")
           "* TODO %?" :prepend t)
          ("n" "Personal (n)otes" entry
           (file+headline "roam/Slipbox.org" "NOTEs")
           "* %U %?" :prepend t)
          ("j" "Bullet (j)ournal" entry
           (file+olp+datetree "roam/main/bujo.org")
           "* %u %?"
           :tree-type month
           ;;       :prepend t  ;;set to no-nil = new node on the top
           )
          )))


;;; org-roam

;; org-roam-templates
;; refrence from https://jethrokuan.github.io/org-roam-guide/
(setq org-roam-capture-templates
      '(("m" "main" plain
         "* ${title} %?"
         :if-new (file+head "main/${slug}.org" "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("r" "reference" plain "* ${title} %?"
         :if-new
         (file+head "reference/${title}.org" "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("a" "article" plain "* ${title} %?"
         :if-new
         (file+head "articles/${title}.org" "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("e" "entity" plain "* ${title} %?"
         :if-new
         (file+head "entity/${title}.org" "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("s" "slipbox" plain "%?"
         :if-new (file+head+olp "Slipbox.org" "#+title: Slipbox\n" ("NODEs" "%U ${title}"))
         :immediate-finish t)
;;
;;        ("p" "daily preview" plain
;;         "# %<%Y年%m月%d日 %A (第%W/52周 第%j天)>\n# 来自昨天的私语\n%? \n# 今日计划\n| item | plan time | actual use | done? |\n|------+-----------+------------+-------|\n|      |           |            |       |\n# 今日回顾\n"
;;         :target (file+head+olp "DAILY.org" ""
;;                                ("Dailies" "%<%Y-%m-%d %a>"))
;;         :empty-lines-after 2
;;         :unnarrowed t)
        ))

;; Creating the property “type”
(after! org-roam
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error ""))))

;; Modifying the display template to show the node “type”
;;(setq org-roam-node-display-template
;;      (concat "${type:15} ${title:50} " (propertize "${tags}" 'face 'org-tag)))
(setq org-roam-node-display-template
      (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))

;; Every Zettel is a Draft until Declared Otherwise
(defun jethro/tag-new-node-as-draft ()
  (org-roam-tag-add '("draft")))
(add-hook 'org-roam-capture-new-node-hook #'jethro/tag-new-node-as-draft)


;;; org-roam ref will bib & citar
(defconst nic/bib-file (concat "/mnt/c/Users/NicEu/OneDrive/Documents/_00PersonalDocuments/OrgNote/notes/roam/biblio.bib"))
(setq org-cite-global-bibliography (list nic/bib-file)
      citar-bibliography org-cite-global-bibliography)



;;; org-roam-ui
;;setq
(setq org-roam-ui-sync-theme t
      org-roam-ui-follow t
      org-roam-ui-update-on-save t
      org-roam-ui-open-on-start t)

;;bind key
(map! :n "SPC n r u" #'org-roam-ui-mode)


;;; citar
(setq citar-notes-paths (list "~/org/roam/reference")
;;      citar-library-paths (list "/mnt/c/Users/NicEu/OneDrive/Documents/_00PersonalDocuments/Zotero")
      )



;;=============================================================================
;;                              My config.el End
;;=============================================================================


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.