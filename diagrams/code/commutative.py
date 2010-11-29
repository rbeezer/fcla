####(c)
####(c)  This file is a portion of the source for the textbook
####(c)
####(c)    A First Course in Linear Algebra
####(c)    Copyright 2004 by Robert A. Beezer
####(c)
####(c)  See the file COPYING.txt for copying conditions
####(c)
####(c)

import sys
from pyx import *

# Global settings for each picture
#
# Most of the book is laid out in inches (sorry!)
# Epsilon is a good set-off from boxes and lines
#
unit.set(defaultunit = "inch")
epsilon=0.1
#
# TeX setup, just "import" math macros in LaTeX
# All TeX is at 10 point (I think)
#
text.set(mode="latex")
text.preamble("\\usepackage{fcla-math}")
#
# Center boxes of text on reference points
#
centerboxstyle = [text.halign.center, text.valign.middle]
#
# Arrowheads, 0.08 inches looks good (at end)
#
arrowheadstyle = [deco.earrow(size=0.08)]
dashedarrowheadstyle = [style.linestyle.dashed, deco.earrow(size=0.08)]



# DTSLS:  Decision Tree for Solving Linear Systems 
#   Not really a commutative diagram, but is text and arrows
def DTSLE():
  # Guides - vertical and horizontal markers 
  #   All placement relative to these marks
  #   Determined experimentally
  v1=0.0
  v2=v1+0.75
  v3=v2+0.4
  v4=v3+0.9
  h1=0.0
  h2=h1+0.6
  h3=h2+0.6
  h4=h3+0.5
  
  c=canvas.canvas()
  
  RCLS = c.text(h3,v4,"Theorem RCLS", centerboxstyle)
  consistent = c.text(h2,v3, "Consistent", centerboxstyle)
  inconsistent = c.text(h4,v3, "Inconsistent", centerboxstyle)
  
  consistentbranch = path.line(h3-epsilon, v4-0.5*RCLS.height-epsilon, h2, v3+0.5*consistent.height+epsilon)
  c.stroke(consistentbranch, arrowheadstyle)
  inconsistentbranch = path.line(h3+epsilon, v4-0.5*RCLS.height-epsilon, h4, v3+0.5*inconsistent.height+epsilon)
  c.stroke(inconsistentbranch, arrowheadstyle)
  # Off midpoints of lines
  c.text(0.5*(h3-epsilon+h2)-epsilon, 0.5*(v4-0.5*RCLS.height+v3+0.5*consistent.height), "no leading 1 in\\\\column $n+1$", [text.halign.right, text.valign.bottom, text.parbox(1.0)])
  c.text(0.5*(h3+epsilon+h4)+epsilon, 0.5*(v4-0.5*RCLS.height+v3+0.5*inconsistent.height), "a leading 1 in\\\\column $n+1$", [text.halign.left, text.valign.bottom, text.parbox(0.85)])
  
  FVCS = c.text(h2, v2, "Theorem FVCS", centerboxstyle)
  branch = path.line( h2, v3-0.5*consistent.height-epsilon, h2, v2+0.5*FVCS.height+epsilon )
  c.stroke( branch, arrowheadstyle)
  
  infinite = c.text(h1, v1, "Infinite solutions", centerboxstyle)
  uniq = c.text(h3,v1,"Unique solution", centerboxstyle)
  infinitebranch = path.line( h2-epsilon, v2-0.5*FVCS.height-epsilon, h1, v1+0.5*uniq.height+epsilon)
  c.stroke(infinitebranch,arrowheadstyle)
  uniqbranch = path.line(h2+epsilon, v2-0.5*FVCS.height-epsilon, h3, v1+0.5*uniq.height+epsilon)
  c.stroke(uniqbranch, arrowheadstyle)
  # Off midpoints of lines
  c.text(0.5*(h2-epsilon+h1)-epsilon, 0.5*(v2-0.5*FVCS.height+v1+0.5*uniq.height),  "$r<n$", [text.halign.right, text.valign.bottom] )
  c.text(0.5*(h2+epsilon+h3)+epsilon, 0.5*(v2-0.5*FVCS.height+v1+0.5*uniq.height), "$r=n$",  [text.halign.left, text.valign.bottom])
  
  c.writePDFfile( finalpdfdir + "DTSLS.pdf" )



# Techniques for column and row spaces
#   Again, textual, but not a commutative diagram yet
#
def CSRST():

  # Guides - vertical and horizontal markers 
  #   All placement relative to these marks
  #   Determined experimentally
  v1=0.0
  v2=v1+1.2
  vsep=0.11
  h1=0.0
  h2=h1+0.9
  
  leftmidstyle = [text.valign.middle, text.halign.left]

  c=canvas.canvas()

  # Textual areas for column space, row space
  rs = c.text(h1, v1, "$\\rsp{A}$", leftmidstyle )
  cs = c.text(h1, v2, "$\\csp{A}$", leftmidstyle )
  
  # Textual areas for 4x2 techniques
  # vsep is half the distance between boxes
  csm = c.text(h2, v2+3*vsep, "Definition CSM", leftmidstyle )
  bcs = c.text(h2, v2+1*vsep, "Theorem BCS", leftmidstyle )
  fsl = c.text(h2, v2-1*vsep, "Theorem FS, $\\nsp{L}$", leftmidstyle )
  rtr = c.text(h2, v2-3*vsep, "Theorem CSRST, $\\rsp{\\transpose{A}}$", leftmidstyle )
  
  ctr = c.text(h2, v1+3*vsep, "Definition RSM, $\\csp{\\transpose{A}}$", leftmidstyle )
  fsc = c.text(h2, v1+1*vsep, "Theorem FS, $\\rsp{C}$", leftmidstyle )
  brs = c.text(h2, v1-1*vsep, "Theorem BRS", leftmidstyle )
  rsm = c.text(h2, v1-3*vsep, "Definition RSM", leftmidstyle )
  
  # Straight arrows
  arrow = path.line(h1+cs.width, v2, h2, v2+3*vsep)
  c.stroke(arrow, arrowheadstyle)
  arrow = path.line(h1+cs.width, v2, h2, v2+1*vsep)
  c.stroke(arrow, arrowheadstyle)
  arrow = path.line(h1+cs.width, v2, h2, v2-1*vsep)
  c.stroke(arrow, arrowheadstyle)
  arrow = path.line(h1+cs.width, v2, h2, v2-3*vsep)
  c.stroke(arrow, arrowheadstyle)
  
  arrow = path.line(h1+rs.width, v1, h2, v1+3*vsep)
  c.stroke(arrow, arrowheadstyle)
  arrow = path.line(h1+rs.width, v1, h2, v1+1*vsep)
  c.stroke(arrow, arrowheadstyle)
  arrow = path.line(h1+rs.width, v1, h2, v1-1*vsep)
  c.stroke(arrow, arrowheadstyle)
  arrow = path.line(h1+rs.width, v1, h2, v1-3*vsep)
  c.stroke(arrow, arrowheadstyle)
  
  # Recursive operations into other half
  squiggle = path.curve(h2+ctr.width, v1+3*vsep, h2+ctr.width+4*epsilon, v1+5*vsep, h2+0.5*ctr.width, 0.5*(v1+v2)-vsep, h2, 0.5*(v1+v2))
  squiggle.extend([path.curveto(0.5*(h1+h2), 0.5*(v1+v2)+0.5*vsep, h1+cs.width, v2-3*vsep, h1+0.5*cs.width, v2-cs.depth-epsilon)])
  c.stroke(squiggle, dashedarrowheadstyle)

  squiggle = path.curve(h2+rtr.width, v2-3*vsep, h2+rtr.width+4*epsilon, v2-5*vsep, h2+0.5*rtr.width, 0.5*(v1+v2)+vsep, h2, 0.5*(v1+v2))
  squiggle.extend([path.curveto(0.5*(h1+h2), 0.5*(v1+v2)-0.5*vsep, h1+rs.width, v1+3*vsep, h1+0.5*rs.width, v1+rs.height+epsilon)])
  c.stroke(squiggle, dashedarrowheadstyle)

  c.writePDFfile( finalpdfdir + "CSRST.pdf" )



# DLTA: Definition of Linear Transformation (Additive)
#
def DLTA():
	
  # Guides - vertical and horizontal markers 
  #   All placement relative to these marks
  #   Determined experimentally
  v1=0.0
  v2=1.0
  h1=0.0
  h2=2.50

  c=canvas.canvas()

  # Textual areas
  vects = c.text(h1, v2, "$\\vect{u}_1,\\,\\vect{u}_2$", centerboxstyle )
  vectsum = c.text(h1, v1, "$\\vect{u}_1+\\vect{u}_2$", centerboxstyle )
  outputs = c.text(h2, v2, "$\lt{T}{\\vect{u}_1},\\,\lt{T}{\\vect{u}_2}$", centerboxstyle )
  outputsum = c.text(h2, v1, "$\lt{T}{\\vect{u}_1+\\vect{u}_2}=\lt{T}{\\vect{u}_1)+T(\\vect{u}_2}$", centerboxstyle )


  # Adorned arrows
  toparrow = path.line( h1+0.5*vects.width+epsilon, v2, h2 - 0.5*outputs.width-epsilon, v2 )
  c.stroke(toparrow, arrowheadstyle)
  c.text( 0.5*(h1+0.5*vects.width + h2 - 0.5*outputs.width), v2+epsilon, "$T$", [text.halign.center, text.valign.baseline] )

  bottomarrow = path.line( h1+0.5*vectsum.width+epsilon, v1, h2 - 0.5*outputsum.width-epsilon, v1 )
  c.stroke(bottomarrow, arrowheadstyle)
  c.text( 0.5*(h1+0.5*vectsum.width + h2 - 0.5*outputsum.width), v1+epsilon, "$T$", [text.halign.center, text.valign.baseline] )

  leftarrow = path.line( h1, v2 - 0.5*vects.height - epsilon, h1, v1 + 0.5*vectsum.height+epsilon )
  c.stroke( leftarrow, arrowheadstyle )
  c.text( h1 + epsilon, 0.5*(v2 - 0.5*vects.height + v1 + 0.5*vectsum.height), "$+$", [text.halign.left, text.valign.middle] )

  rightarrow = path.line( h2, v2 - 0.5*outputs.height - epsilon, h2, v1 + 0.5*outputsum.height+epsilon )
  c.stroke( rightarrow, arrowheadstyle )
  c.text( h2 + epsilon, 0.5*(v2 - 0.5*outputs.height + v1 + 0.5*outputsum.height), "$+$", [text.halign.left, text.valign.middle] )

  c.writePDFfile( finalpdfdir + "DLTA.pdf" )

# DLTM: Definition of Linear Transformation (Multiplicative)
#
def DLTM():

  # Guides - vertical and horizontal markers 
  #   All placement relative to these marks
  #   Determined experimentally
  v1=0.0
  v2=1.0
  h1=0.0
  h2=1.75

  c=canvas.canvas()

  # Textual areas (box names recycled from additive diagram, so not as meaningful here)
  vects = c.text(h1, v2, "$\\vect{u}$", centerboxstyle )
  vectsum = c.text(h1, v1, "$\\alpha\\vect{u}$", centerboxstyle )
  outputs = c.text(h2, v2, "$\\lt{T}{\\vect{u}}$", centerboxstyle )
  outputsum = c.text(h2, v1, "$\\lt{T}{\\alpha\\vect{u}}=\\alpha\\lt{T}{\\vect{u}}$", centerboxstyle )


  # Adorned arrows
  toparrow = path.line( h1+0.5*vects.width+epsilon, v2, h2 - 0.5*outputs.width-epsilon, v2 )
  c.stroke(toparrow, arrowheadstyle)
  c.text( 0.5*(h1+0.5*vects.width + h2 - 0.5*outputs.width), v2+epsilon, "$T$", [text.halign.center, text.valign.baseline] )

  bottomarrow = path.line( h1+0.5*vectsum.width+epsilon, v1, h2 - 0.5*outputsum.width-epsilon, v1 )
  c.stroke(bottomarrow, arrowheadstyle)
  c.text( 0.5*(h1+0.5*vectsum.width + h2 - 0.5*outputsum.width), v1+epsilon, "$T$", [text.halign.center, text.valign.baseline] )

  leftarrow = path.line( h1, v2 - 0.5*vects.height - epsilon, h1, v1 + 0.5*vectsum.height+epsilon )
  c.stroke( leftarrow, arrowheadstyle )
  c.text( h1 + epsilon, 0.5*(v2 - 0.5*vects.height + v1 + 0.5*vectsum.height), "$\\alpha$", [text.halign.left, text.valign.middle] )

  rightarrow = path.line( h2, v2 - 0.5*outputs.height - epsilon, h2, v1 + 0.5*outputsum.height+epsilon )
  c.stroke( rightarrow, arrowheadstyle )
  c.text( h2 + epsilon, 0.5*(v2 - 0.5*outputs.height + v1 + 0.5*outputsum.height), "$\\alpha$", [text.halign.left, text.valign.middle] )

  c.writePDFfile( finalpdfdir + "DLTM.pdf" )

# Fundamental Theorem of matrix representation
#  
def FTMR():
  
  # Guides - vertical and horizontal markers 
  #   All placement relative to these marks
  #   Determined experimentally
  v1=0.0
  v2=v1+0.8
  h1=0.0
  h2=h1+2.25

  c=canvas.canvas()

  # Textual areas (box names recycled from additive diagram, so not as meaningful here)
  vector = c.text(h1, v2, "$\\vect{u}$", centerboxstyle )
  represent = c.text(h1, v1, "$\\vectrep{B}{\\vect{u}}$", centerboxstyle )
  ltaction = c.text(h2, v2, "$\\lt{T}{\\vect{u}}$", centerboxstyle )
  theorem = c.text(h2, v1, "$\\matrixrep{T}{B}{C}\\vectrep{B}{\\vect{u}}=\\vectrep{C}{\\lt{T}{\\vect{u}}}$", centerboxstyle )


  # Adorned arrows
  toparrow = path.line( h1+0.5*vector.width+epsilon, v2, h2 - 0.5*ltaction.width-epsilon, v2 )
  c.stroke(toparrow, arrowheadstyle)
  c.text( 0.5*(h1+0.5*vector.width + h2 - 0.5*ltaction.width), v2+epsilon, "$T$", [text.halign.center, text.valign.baseline] )

  bottomarrow = path.line( h1+0.5*represent.width+epsilon, v1, h2 - 0.5*theorem.width-epsilon, v1 )
  c.stroke(bottomarrow, arrowheadstyle)
  c.text( 0.5*(h1+0.5*represent.width + h2 - 0.5*theorem.width), v1+epsilon, "$\\matrixrep{T}{B}{C}$", [text.halign.center, text.valign.baseline] )

  leftarrow = path.line( h1, v2 - 0.5*vector.height - epsilon, h1, v1 + 0.5*represent.height+epsilon )
  c.stroke( leftarrow, arrowheadstyle )
  c.text( h1 - epsilon, 0.5*(v2 - 0.5*vector.height + v1 + 0.5*represent.height), "$\\vectrepname{B}$", [text.halign.right, text.valign.middle] )

  rightarrow = path.line( h2, v2 - 0.5*ltaction.height - epsilon, h2, v1 + 0.5*theorem.height+epsilon )
  c.stroke( rightarrow, arrowheadstyle )
  c.text( h2 + epsilon, 0.5*(v2 - 0.5*ltaction.height + v1 + 0.5*theorem.height), "$\\vectrepname{C}$", [text.halign.left, text.valign.middle] )

  c.writePDFfile( finalpdfdir + "FTMR.pdf" )



# Fundamental Theorem of matrix representation, Alternate
# Just like FTMR, but follow three sides to T(u)
#  
def FTMRA():
  
  # Guides - vertical and horizontal markers 
  #   All placement relative to these marks
  #   Determined experimentally
  v1=0.0
  v2=v1+0.8
  h1=0.0
  h2=h1+2.25

  c=canvas.canvas()

  # Textual areas (box names recycled from additive diagram, so not as meaningful here)
  vector = c.text(h1, v2, "$\\vect{u}$", centerboxstyle )
  represent = c.text(h1, v1, "$\\vectrep{B}{\\vect{u}}$", centerboxstyle )
  ltaction = c.text(h2, v2, "$\\lt{T}{\\vect{u}}=\\vectrepinv{C}{\\matrixrep{T}{B}{C}\\vectrep{B}{\\vect{u}}}$", centerboxstyle )
  theorem = c.text(h2, v1, "$\\matrixrep{T}{B}{C}\\vectrep{B}{\\vect{u}}$", centerboxstyle )


  # Adorned arrows
  toparrow = path.line( h1+0.5*vector.width+epsilon, v2, h2 - 0.5*ltaction.width-epsilon, v2 )
  c.stroke(toparrow, arrowheadstyle)
  c.text( 0.5*(h1+0.5*vector.width + h2 - 0.5*ltaction.width), v2+epsilon, "$T$", [text.halign.center, text.valign.baseline] )

  bottomarrow = path.line( h1+0.5*represent.width+epsilon, v1, h2 - 0.5*theorem.width-epsilon, v1 )
  c.stroke(bottomarrow, arrowheadstyle)
  c.text( 0.5*(h1+0.5*represent.width + h2 - 0.5*theorem.width), v1+epsilon, "$\\matrixrep{T}{B}{C}$", [text.halign.center, text.valign.baseline] )

  leftarrow = path.line( h1, v2 - 0.5*vector.height - epsilon, h1, v1 + 0.5*represent.height+epsilon )
  c.stroke( leftarrow, arrowheadstyle )
  c.text( h1 - epsilon, 0.5*(v2 - 0.5*vector.height + v1 + 0.5*represent.height), "$\\vectrepname{B}$", [text.halign.right, text.valign.middle] )

  # Reversed the ends, and inverted label
  rightarrow = path.line( h2, v1 + 0.5*theorem.height+epsilon, h2, v2 - 0.5*ltaction.height - epsilon )
  c.stroke( rightarrow, arrowheadstyle )
  c.text( h2 + epsilon, 0.5*(v2 - 0.5*ltaction.height + v1 + 0.5*theorem.height), "$\\vectrepinvname{C}$", [text.halign.left, text.valign.middle] )

  c.writePDFfile( finalpdfdir + "FTMRA.pdf" )


# Matrix representation of a composition
#
def MRCLT():

  # Guides - vertical and horizontal markers 
  #   All placement relative to these marks
  #   Determined experimentally
  v1=0.0
  v2=v1+0.8
  h1=0.0
  h2=h1+2.35

  c=canvas.canvas()

  # Textual areas (box names recycled from additive diagram, so not as meaningful here)
  lts = c.text(h1, v2, "$S,\\,T$", centerboxstyle )
  compose = c.text(h1, v1, "$\\compose{S}{T}$", centerboxstyle )
  reps = c.text(h2, v2, "$\\matrixrep{S}{C}{D},\\,\\matrixrep{T}{B}{C}$", centerboxstyle )
  product = c.text(h2, v1, "$\\matrixrep{\\compose{S}{T}}{B}{D}=\\matrixrep{S}{C}{D}\\matrixrep{T}{B}{C}$", centerboxstyle )


  # Adorned arrows
  toparrow = path.line( h1+0.5*lts.width+epsilon, v2, h2 - 0.5*reps.width-epsilon, v2 )
  c.stroke(toparrow, arrowheadstyle)
  c.text( 0.5*(h1+0.5*lts.width + h2 - 0.5*reps.width), v2+epsilon, "Definition MR", [text.halign.center, text.valign.baseline] )

  # Text label aligns exactly with identical one above
  bottomarrow = path.line( h1+0.5*compose.width+epsilon, v1, h2 - 0.5*product.width-epsilon, v1 )
  c.stroke(bottomarrow, arrowheadstyle)
  c.text(0.5*(h1+0.5*lts.width + h2 - 0.5*reps.width), v1-epsilon, "Definition MR", [text.halign.center, text.valign.top] )

  leftarrow = path.line( h1, v2 - 0.5*lts.height - epsilon, h1, v1 + 0.5*compose.height+epsilon )
  c.stroke( leftarrow, arrowheadstyle )
  c.text( h1 - epsilon, 0.5*(v2 - 0.5*lts.height + v1 + 0.5*compose.height), "Definition LTC", [text.halign.right, text.valign.middle] )

  rightarrow = path.line( h2, v2-0.5*reps.height-epsilon, h2, v1+0.5*product.height+epsilon )
  c.stroke( rightarrow, arrowheadstyle )
  c.text( h2+epsilon, 0.5*(v2-0.5*reps.height+v1+0.5*product.height), "Definition MM", [text.halign.left, text.valign.middle] )

  c.writePDFfile( finalpdfdir + "MRCLT.pdf" )
  
  
  
# Main section

# Command line needs a directory, with trailing slash
if len(sys.argv) > 1 :
  finalpdfdir = sys.argv[1]
else:
  finalpdfdir = "./"

#   call individual routines, per diagram
DTSLE()
CSRST()
DLTA()
DLTM()
FTMR()
FTMRA()
MRCLT()
