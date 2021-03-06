;;; asdf.lisp --- ASDF Utilities

;; Copyright (C) 2010, 2011, 2013 Didier Verna

;; Author: Didier Verna <didier@didierverna.net>

;; This file is part of Declt.

;; Declt is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License version 3,
;; as published by the Free Software Foundation.

;; Declt is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


;;; Commentary:



;;; Code:

(in-package :com.dvlsoft.declt)
(in-readtable :com.dvlsoft.declt)


;; ==========================================================================
;; Miscellaneous
;; ==========================================================================

(defun relative-location (component relative-to)
  "Return COMPONENT's location RELATIVE-TO."
  (enough-namestring (component-pathname component) relative-to))

(defun components (module type)
  "Return the list of all components of (sub)TYPE from ASDF MODULE."
  ;; #### NOTE: we accept subtypes of TYPE because ASDF components might be
  ;; subclassed. An example of this is SBCL's grovel facility which subclasses
  ;; asdf:cl-source-file.
  (loop :for component :in (asdf:module-components module)
	:if (typep component type)
	  :collect component
	:if (typep component 'asdf:module)
	  :nconc (components component type)))

(defun lisp-components (module)
  "Return the list of all Lisp source file components from ASDF MODULE."
  (components module 'asdf:cl-source-file))

;; #### WARNING: do not confuse this function with asdf:module-components!
(defun module-components (module)
  "Return the list of all module components from ASDF MODULE."
  (components module 'asdf:module))

(defun system-directory (system)
  "Return ASDF SYSTEM's directory."
  (component-pathname system))

(defun system-base-name (system)
  "Return the basename part of ASDF SYSTEM's definition file."
  (file-namestring (system-source-file system)))

(defun system-file-name (system)
  "Return the name part of ASDF SYSTEM's definition file."
  (pathname-name (system-source-file system)))

(defun system-file-type (system)
  "Return the type part of ASDF SYSTEM's definition file."
  (pathname-type (system-source-file system)))


;;; asdf.lisp ends here
