;;; component.lisp --- ASDF component documentation

;; Copyright (C) 2010 Didier Verna

;; Author:        Didier Verna <didier@lrde.epita.fr>
;; Maintainer:    Didier Verna <didier@lrde.epita.fr>
;; Created:       Wed Aug 25 16:06:07 2010
;; Last Revision: Wed Aug 25 16:54:11 2010

;; This file is part of Declt.

;; Declt is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

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


;; ==========================================================================
;; Documentation Protocols
;; ==========================================================================

(defgeneric document-component (component relative-to)
  (:documentation "Render COMPONENT's documentation.")
  (:method :around ((component asdf:component) relative-to)
    "Index COMPONENT and enclose its documentation in a @table environment."
    (index component relative-to)
    (@table ()
      (call-next-method)))
  (:method ((component asdf:component) relative-to)
    (format t "~@[@item Version~%~A~%~]"
      (escape (component-version component)))
    ;; #### NOTE: currently, we simply extract all the dependencies regardless
    ;; of the operations involved. We also assume that dependencies are of the
    ;; form (OP (OP DEP...) ...), but I'm not sure this is always the case.
    (let ((in-order-tos (slot-value component 'asdf::in-order-to))
	  dependencies)
      (when in-order-tos
	(dolist (in-order-to in-order-tos)
	  (dolist (op-dependency (cdr in-order-to))
	    (dolist (dependency (cdr op-dependency))
	      (pushnew dependency dependencies))))
	(format t "@item Dependencies~%")
	(@itemize-list dependencies :format "@t{~(~A}~)" :key #'escape)))
    (let ((parent (component-parent component)))
      (when parent
	(format t "@item Parent~%")
	(index parent relative-to)
	(format t "@t{~A}~%" (escape parent))))
    (if (eq (type-of component) 'asdf:system) ;; Yuck!
	(when *link-files*
	  (format t "@item Source Directory~%~
		      @url{file://~A, ignore, @t{~A}}~%"
	    (escape (component-pathname component))
	    (escape (component-pathname component)))
	  (let ((directory (escape
			    (directory-namestring
			     (system-definition-pathname component)))))
	    (format t "@item Installation Directory~%~
			@url{file://~A, ignore, @t{~A}}~%"
	      directory directory)))
      (render-location component relative-to))))


;;; component.lisp ends here
