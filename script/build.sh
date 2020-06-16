#!/bin/bash

## This file is part of the book                ##
##                                              ##
##      A First Course in Linear Algebra        ##
##                                              ##
## Copyright (C) 2004-2017  Robert A. Beezer    ##
## See the file COPYING for copying conditions. ##

# FCLA build script

# Be sure to make this file executable, and run with path
# i.e.  $ chmod 700 build.sh
# e.g.  [soundwriting/script] $ ./build.sh

# Source a custom file with three path names
# See paths.sh.template, copy to paths.sh and edit
# "dot" syntax is POSIX for "source"
# Alternatives: http://stackoverflow.com/questions/192292
DIR="$(dirname "$0")"
. ${DIR}/paths.sh

# following depend on paths source'd above
declare MBXSL=${MBX}/xsl
declare MBXSCR=${MBX}/script
declare MBUSER=${MBX}/user
declare SOURCE=${SRC}/src2
declare IMAGES=${SRC}/src2/images

# convenience for rsync command, hopefully not OS dependent
# First does not include  --delete  switch at end due to PDF in directory
# Second makes *exact* mirror of build directory
declare RSYNC="rsync --verbose  --progress --stats --compress --rsh=/usr/bin/ssh --recursive"
declare RSYNCDELETE="rsync --verbose  --progress --stats --compress --rsh=/usr/bin/ssh --recursive --delete "

# website upload parameterized by username
declare UNAME="$2"

# useful date string
# http://stackoverflow.com/questions/1401482
declare DATE=`date +%Y-%m-%d`

# Common setup
function setup {
    # not necessary, but always build scratch directory first
    echo
    echo "BUILD: Setup Scratch Directory :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}

    # Always place/update `ups-writers` in `mathbook/contrib`
    echo
    echo "BUILD: Update Custom XSL :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${MBUSER}

    cp ${SRC}/xsl/fcla-common.xsl  ${MBUSER}
    cp ${SRC}/xsl/fcla-html.xsl    ${MBUSER}
    cp ${SRC}/xsl/fcla-aim.xsl    ${MBUSER}
    cp ${SRC}/xsl/fcla-latex.xsl   ${MBUSER}
    cp ${SRC}/xsl/fcla-pod.xsl   ${MBUSER}
}

# Subroutine to check XML structure/syntax
function xml_check {
    echo
    echo "BUILD: Checking XML Syntax :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    xmllint --xinclude --noout ${SOURCE}/fcla.xml
}

# Subroutine to build the PDF Version
function pdf_build {
    echo
    echo "BUILD: Building PDF Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}/pdf ${SCRATCH}/pdf/images
    cd ${SCRATCH}/pdf
    rm fcla.tex
    cp -a ${IMAGES}/* ./images/
    xsltproc -o fcla.tex --xinclude ${MBUSER}/fcla-latex.xsl ${SOURCE}/fcla.xml
    # twice?  Try xelatex, change filename here, and in view
    pdflatex fcla.tex
    pdflatex fcla.tex
}

# Subroutine to build the print-on-demand Version
function pod_build {
    echo
    echo "BUILD: Building POD Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}/pod ${SCRATCH}/pod/images
    cd ${SCRATCH}/pod
    rm fcla-pod.tex
    cp -a ${IMAGES}/* ./images/
    xsltproc -o fcla-pod.tex --xinclude ${MBUSER}/fcla-pod.xsl ${SOURCE}/fcla.xml
    # twice?  Try xelatex, change filename here, and in view
    xelatex fcla-pod.tex
    xelatex fcla-pod.tex
}

# Subroutine to build the HTML Version
function html_build {
    echo
    echo "BUILD: Building HTML Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}/html ${SCRATCH}/html/images ${SCRATCH}/html/knowl
    cd ${SCRATCH}/html
    # rm *.html
    # rm -rf knowl/* images/*
    # svg and pdf for archive links
    # png is cover
    cp -a ${IMAGES}/*.svg ${IMAGES}/*.pdf ${IMAGES}/*.png ./images/
    xsltproc -xinclude -stringparam publisher ../publisher/public.xml ${MBUSER}/fcla-html.xsl ${SOURCE}/fcla.xml
}

# Subroutine to build the AIM HTML Version
# Right Google ID via sed, two-level ToC via toc.level stringparam
# EG: http://mathbook.pugetsound.edu/beta/fcla-html-2017-02-19.zip
function aim_html_build {
    echo
    echo "BUILD: Building AIM ZIPPED HTML Version :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    declare ZIPFILE=fcla-html-${DATE}.zip
    install -d ${SCRATCH}/fcla-html ${SCRATCH}/fcla-html/images ${SCRATCH}/fcla-html/knowl
    cd ${SCRATCH}/fcla-html
    # rm *.html
    # rm -rf knowl/* images/*
    cp -a ${SOURCE}/*.xml .
    # move over the publisher file, too, with all source XML
    cp -a ${SOURCE}/../publisher/AIM-test-sites.xml .
    # svg and pdf for archive links
    # png is cover
    cp -a ${IMAGES}/*.svg ${IMAGES}/*.pdf  ${IMAGES}/*.png ./images/
    # Sage/computation temporarily unknowled
    xsltproc -xinclude -stringparam publisher AIM-test-sites.xml --stringparam toc.level 2 -stringparam html.knowl.remark no ${MBUSER}/fcla-html.xsl fcla.xml
    # clean-up, pop up a level, make zip
    rm *.xml
    cd ${SCRATCH}
    zip -r ${ZIPFILE} fcla-html/
    ${RSYNCDELETE} ${ZIPFILE} utmost@utmost.aimath.org:/home/utmost/www/pretextbook.org/htdocs/beta
    echo "Dropped in http://pretextbook.org/beta/"${ZIPFILE}
}

function doctest {
    echo
    echo "BUILD: Creating Sage Doctests :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}/doctest
    cd ${SCRATCH}/doctest
    rm *.py
    xsltproc --stringparam chunk.level 2 --xinclude ${MBXSL}/pretext-sage-doctest.xsl ${SOURCE}/fcla.xml
    echo
    echo "BUILD: Doctest'ing Sage code :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    ${SAGE} -t .
}

function imagegen {
    echo
    echo "BUILD: Building SVG PDF images :BUILD"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    install -d ${SCRATCH}/imagegen
    ${MBXSCR}/mbx -c latex-image -f svg -d ${SCRATCH}/imagegen ${SOURCE}/fcla.xml
    ${MBXSCR}/mbx -c latex-image -f pdf -d ${SCRATCH}/imagegen ${SOURCE}/fcla.xml
}


function view_html {
    ${HTMLVIEWER} ${SCRATCH}/html/index.html
}

function view_pdf {
    ${PDFVIEWER} ${SCRATCH}/pdf/index.pdf &
}

function view_pod {
    ${PDFVIEWER} ${SCRATCH}/pod/index.pdf &
}

# $2 is a username with priviliges at
# /var/www/html/soundwriting.pugetsound.edu/ on userweb.pugetsound.edu
function website {
    # test for zero string as account name and exit with message
    if [ -z "${UNAME}" ] ; then
        echo
        echo "BUILD: Website upload needs an account username, quitting... :BUILD"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        exit
    fi
    echo
    echo "BUILD: rsync entire web version...                      :BUILD"
    echo "BUILD: username as parameter 2, then supply password... :BUILD"
    echo
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    # build it first, cleanly
    build_html
    ${RSYNC} ${SCRATCH}/html/*  ${UNAME}@userweb.pugetsound.edu:/var/www/html/soundwriting.pugetsound.edu/beta
}

# Main command-line interpreter
case "$1" in
    "xmlcheck")
    xml_check
    ;;
    "pdf")
    setup
    pdf_build
    ;;
    "pod")
    setup
    pod_build
    ;;
    "html")
    setup
    html_build
    ;;
    "aimzip")
    setup
    aim_html_build
    ;;
    "doctest")
    setup
    doctest
    ;;
    "imagegen")
    setup
    imagegen
    ;;
    "website")
    website
    ;;
    "viewpdf")
    view_pdf
    ;;
    "viewpod")
    view_pod
    ;;
    "viewhtml")
    view_html
    ;;
    *)
    echo "Supply an option: xmlcheck|pdf|html|aimzip|doctest|imagegen|website <username>|viewpdf|viewhtml"
    ;;
esac
