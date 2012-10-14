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
import math
from pyx import *

# Global settings for each picture
#
# Most of the book is laid out in inches (sorry!)
# Epsilon is a good set-off from boxes and lines
#
unit.set(defaultunit = "inch")
epsilon=0.1

# Relative scaling of linear transformation pictures
#   Domain will be centered at (0,0)
#   height will be (roughly) the desired true height of a diagram
#   seperation is the distance to the center of the codomain 
#     thus codomain is centered at (seperation, 0)
#   smaller makes a vector space proportionally less tall, golden-ratio
height = 2.5
seperation = height
smaller = 0.618

#
# TeX setup, just "import" math macros in LaTeX
# All TeX is at 10 point (I think)
#
text.set(mode="latex")
text.preamble("\\usepackage{fcla-math}")
#


def draw_vector_space( canvas, scale,  x,  y ):
  # Scale is entire height of the ellipse
  # Resultant width makes bounding rectangle have golden-ratio dimensions
  
  circ = path.circle(0,0,1)
  ellipse = circ.transformed( trafo.scale(0.309*scale, 0.5*scale) )
  vsp = ellipse.transformed(trafo.translate(x, y))
  canvas.stroke( vsp )
  return vsp


def draw_legend( canvas, domainscale, domainx, domainy, codomainscale, codomainx, codomainy, 
	         domainlabel, codomainlabel, ltname ):
  # Locate lowest bottom of vector space ovals
  #
  domainbottom = domainy - 0.5*domainscale
  codomainbottom = codomainy - 0.5*codomainscale
  if (domainbottom < codomainbottom):
    bottom = domainbottom
  else:
    bottom = codomainbottom
  
  # Write vector space names
  #
  domaintext = canvas.text( domainx, bottom - epsilon, domainlabel, [text.valign.top, text.halign.center] )
  codomaintext = canvas.text( codomainx, bottom - epsilon, codomainlabel, [text.valign.top, text.halign.center] )
  
  # Write arrow surmounted by name of linear transformation
  # Arrowhead is proportional to height of codomain label
  # With alignment on top of textboxes, we want the boxes' depths
  #
  arrow = path.line(domainx + 0.5*domaintext.width + 2*epsilon, bottom - epsilon - 0.5*domaintext.depth,
                    codomainx - 0.5*codomaintext.width - 2*epsilon, bottom - epsilon - 0.5*codomaintext.depth )
  canvas.stroke( arrow, [deco.earrow(size=codomaintext.depth)])
  canvas.text( 0.5*(domainx + codomainx + 0.5*(domaintext.width-codomaintext.width)), bottom - epsilon, ltname, [text.halign.center, text.valign.bottom])
  # End of draw_legend()

def draw_orphan( canvas, outputx, outputy, labelout ):

  # One circle for the orphaned output vector
  # Sizing is experimental, relative to design height
  # Label right as in draw_image()
  #
  elementsize = 0.01*height
  element = path.circle(0,0,elementsize)
  v = element.transformed(trafo.translate(outputx, outputy))
  canvas.stroke(v, [deco.filled([color.rgb.black])])
  canvas.text( outputx + elementsize + epsilon, outputy, labelout, [text.valign.middle, text.halign.left] )
  # End draw_orphan()


def draw_image( canvas, inputx, inputy, outputx, outputy, labelin, labelout ):

  # Filled-in circles for the two elements
  # Sizing is experimental, relative to design height
  # Labels to left/right
  #
  elementsize = 0.01*height
  element = path.circle(0,0,elementsize)
  u = element.transformed(trafo.translate(inputx, inputy))
  v = element.transformed(trafo.translate(outputx, outputy))
  canvas.stroke(u, [deco.filled([color.rgb.black])])
  canvas.stroke(v, [deco.filled([color.rgb.black])])
  canvas.text( inputx - elementsize - epsilon, inputy, labelin, [text.valign.middle, text.halign.right] )
  canvas.text( outputx + elementsize + epsilon, outputy, labelout, [text.valign.middle, text.halign.left] )

  # Control points at 1/4, 3/4 horizontally.  Fudge vertical via lift value.
  # Arrowhead just to left, sizing of lift is experimental relative to distance
  #
  lift = 0.10*math.sqrt((inputx-outputx)*(inputx-outputx) + (inputy-outputy)*(inputy-outputy))
  arrow = path.curve(inputx, inputy, 
	           0.75*inputx+0.25*outputx, 0.75*inputy+0.25*outputy + lift,
	           0.25*inputx+0.75*outputx, 0.25*inputy+0.75*outputy + lift,
		   outputx-elementsize, outputy)
  canvas.stroke(arrow, [deco.earrow(size=4*elementsize)])
  # End draw_image()
  
  
# GLT: General Linear Transformation
#   a most general picture of a linear transformation
#   to exhibit most general behavior
#
def GLT ():
  domainx = 0
  domainy= 0
  codomainx = domainx + seperation
  codomainy = domainy
  domainscale = height
  codomainscale = height
  
  c=canvas.canvas( )
  
  # Domain, Codomain, Legend
  #
  draw_vector_space(c, domainscale, domainx, domainy )
  draw_vector_space( c, codomainscale, codomainx, codomainy )
  draw_legend(c, domainscale, domainx, domainy, codomainscale, codomainx, codomainy, "$U$", "$V$", "$T$" )
  
  # Everything
  # Non-injective, non-surjective, 
  draw_image(c, domainx, domainy+0.30*domainscale, codomainx, codomainy+0.30*codomainscale, "$\\vect{u}$", "$\\vect{v}$" )
  draw_image(c, domainx, domainy+0.20*domainscale, codomainx, codomainy+0.30*codomainscale, "$\\vect{w}$", "$\\vect{v}$" )
  draw_image(c, domainx, domainy+0.00*domainscale, codomainx, codomainy+0.00*codomainscale, "$\\zerovector_U$", "$\\zerovector_V$" )
  draw_image(c, domainx, domainy-0.30*domainscale, codomainx, codomainy-0.15*codomainscale, "$\\vect{x}$", "$\\vect{y}$" )
  draw_orphan(c, codomainx, codomainy - 0.30*codomainscale, "$\\vect{t}$" )
  
  c.writePDFfile( finalpdfdir + "GLT.pdf" )


# ILT: Injective Linear Transformation
#   3 pairs images, includes two orphans
#   No labels
#
def ILT ():
  domainx = 0
  domainy= 0
  codomainx = domainx + seperation
  codomainy = domainy
  domainscale = height
  codomainscale = height
  
  c=canvas.canvas( )
  
  # Domain, Codomain, Legend
  #
  draw_vector_space(c, domainscale, domainx, domainy )
  draw_vector_space( c, codomainscale, codomainx, codomainy )
  draw_legend(c, domainscale, domainx, domainy, codomainscale, codomainx, codomainy, "$U$", "$V$", "$T$" )
  
  draw_image(c, domainx, domainy+0.30*domainscale, codomainx, codomainy+0.30*codomainscale, "", "" )
  draw_image(c, domainx, domainy+0.10*domainscale, codomainx, codomainy+0.10*codomainscale, "", "" )
  draw_image(c, domainx, domainy-0.10*domainscale, codomainx, codomainy-0.10*codomainscale, "", "" )
  draw_orphan(c, codomainx-0.1*codomainscale, codomainy - 0.30*codomainscale, "" )
  draw_orphan(c, codomainx+0.1*codomainscale, codomainy - 0.30*codomainscale, "" )
  
  c.writePDFfile( finalpdfdir + "ILT.pdf" )

# NILT: Non-Injective Linear Transformation
#   2 double pre-images, includes two orphans
#   Some labels
#
def NILT ():
  domainx = 0
  domainy= 0
  codomainx = domainx + seperation
  codomainy = domainy
  domainscale = height
  codomainscale = height
  
  c=canvas.canvas( )
  
  # Domain, Codomain, Legend
  #
  draw_vector_space(c, domainscale, domainx, domainy )
  draw_vector_space( c, codomainscale, codomainx, codomainy )
  draw_legend(c, domainscale, domainx, domainy, codomainscale, codomainx, codomainy, "$U$", "$V$", "$T$" )
  
  draw_image(c, domainx, domainy+0.40*domainscale, codomainx, codomainy+0.30*codomainscale, "", "" )
  draw_image(c, domainx, domainy+0.30*domainscale, codomainx, codomainy+0.30*codomainscale, "", "" )
  draw_image(c, domainx, domainy+0.05*domainscale, codomainx, codomainy+0.00*codomainscale, "$\\vect{u}$", "$\\vect{v}$" )
  draw_image(c, domainx, domainy-0.05*domainscale, codomainx, codomainy+0.00*codomainscale, "$\\vect{w}$", "$\\vect{v}$" )
  draw_orphan(c, codomainx-0.1*codomainscale, codomainy - 0.30*codomainscale, "" )
  draw_orphan(c, codomainx+0.1*codomainscale, codomainy - 0.30*codomainscale, "" )
  
  c.writePDFfile( finalpdfdir + "NILT.pdf" )

# Main section

# Command line needs a directory, with trailing slash
if len(sys.argv) > 1 :
  finalpdfdir = sys.argv[1]
else:
  finalpdfdir = "./"
  
#   call individual routines, per diagram
GLT()
ILT()
NILT()
