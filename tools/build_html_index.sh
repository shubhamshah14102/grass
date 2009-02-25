#!/bin/sh

#generates HTML man pages docs/html/index.html
# Markus Neteler, 2003, 2004, 2005, 2006


## TODO: better fix this in include/Make/Html.make, see bug RT #5361

#exclude following list of modules from help index:
EXCLUDEMODS="\
i.find \
r.watershed.ram \
r.watershed.seg \
v.topo.check \
helptext.html \
wxGUI.*"

# these modules don't use G_parser()
check_for_desc_override()
{
    case "$BASENAME" in
	g.parser)
	    SHORTDESC="Provides automated parser, GUI, and help support for GRASS scipts."
	    ;;
	r.li.daemon)
	    SHORTDESC="Support module for r.li landscape index calculations."
	    ;;
    esac
}


############# nothing to configure below ############

# regex-proof module skip list
EXCLUDEHTML="`echo "$EXCLUDEMODS" | tr ' ' '|' | sed -e 's+\.+\\\\.+g' -e 's+|+\\\\|+g'`"

#fetch the ARCH for store the files:
ARCH="`cat ../include/Make/Platform.make | grep '^ARCH'  | sed 's+ ++g' | cut -d'=' -f2`"
GEMDIR="../gem"
HTMLDIR="../dist.$ARCH/docs/html"
GRASSVERSION=`cat ../dist.$ARCH/etc/VERSIONNUMBER`
GRASS_MMVER=`cut -d . -f 1-2 ../dist.$ARCH/etc/VERSIONNUMBER`
MACOSX=`echo $ARCH | grep -i darwin`


write_html_header()
{
# $1: not used
# $2: page title
# $3: is it main index
cat <<EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
 <title>$2</title>
 <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
 <meta name="Author" content="GRASS Development Team">
EOF
if [ "$3" ] && [ "$MACOSX" ] ; then
cat <<EOF
 <meta name="AppleTitle" content="GRASS GIS $GRASSVERSION Help">
 <meta name="AppleIcon" content="GRASS-$GRASS_MMVER/grass_icon.png">
 <meta name="robots" content="anchors">
EOF
fi
cat <<EOF
 <link rel="stylesheet" href="grassdocs.css" type="text/css">
</head>
<body bgcolor="#FFFFFF">

<!-- this file is generated by tools/build_html_index.sh -->

<img src="grass_logo.png" alt="GRASS logo"><hr align=center size=6 noshade>

<h2>GRASS GIS $GRASSVERSION Reference Manual</h2>

<p>
<em>Geographic Resources Analysis Support System</em>, commonly referred to as
<a href="http://grass.osgeo.org">GRASS</a>, 
is a Geographic Information System (GIS) used for geospatial data management
and analysis, image processing, graphics/maps production, spatial modeling,
and visualization. GRASS is currently used in academic and commercial settings
around the world, as well as by many governmental agencies and environmental
consulting companies.</p>

<p>This reference manual details the use of modules distributed with
Geographic Resources Analysis Support System (GRASS), an open source (GNU
GPLed), image processing and geographic information system (GIS).</p>

EOF
}

write_html_cmd_overview()
{
cat <<EOF
<!-- the files grass7.html & helptext.html file live in lib/init/ -->

<table align="center" border="0" cellspacing="8">
  <tbody>
    <tr>
      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;Quick Introduction</h3>
      <ul>
      <li><a href="grass6.html">GRASS startup manual page</a></li>
      <li><a href="helptext.html">How to start with GRASS</a></li>
      </ul></td>

      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;General</h3>
      <ul>
      <li><a href="general.html">General commands manual</a></li>
      </ul></td>
    </tr>
    <tr>
      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;Raster/Image processing</h3>

       <ul>
        <li><a href="rasterintro.html">Intro 2D raster map processing</a></li>
        <li><a href="raster.html">Raster commands manual</a></li>
        <li><a href="raster3dintro.html">Intro 3D raster map (voxel) processing</a></li>
        <li><a href="raster3D.html">Raster3D commands manual</a></li>
      </ul></td>
      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;Vector processing</h3>

       <ul>
        <li><a href="vectorintro.html">Intro vector map processing and network analysis</a></li>
        <li><a href="vector.html">Vector commands manual</a></li>
       </ul></td>
    </tr>
    <tr>
      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;Display/Graphical User Interfaces</h3>

       <ul>
       <li><a href="displaydrivers.html">Display drivers</a></li>
        <li><a href="gis.m.html">gis.m</a> and <a href="d.m.html">d.m</a> GIS managers</li>
        <li><a href="wxGUI.html">wxGUI</a> wxPython-based GUI frontend</li>

        <li><a href="nviz.html">nviz</a> visualization and animation tool</li>
        <li><a href="xganim.html">xganim</a> tool  for animating a raster map series</li>
        <li><a href="display.html">Display commands manual</a></li>
       </ul></td>
      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;Database</h3>

       <ul>
       <li><a href="databaseintro.html">Intro database management</a></li>
       <li><a href="sql.html">SQL support in GRASS GIS</a></li>
       <li><a href="database.html">Database commands manual</a></li>
       </ul></td>
    </tr>
    <tr>

      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;Projections</h3>
       <ul>
        <li><a href="projectionintro.html">Intro projections and spatial transformations</a></li>
       </ul></td>
      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;Miscellaneous</h3>
       <ul>
        <li><a href="variables.html">GRASS variables and environment variables</a></li>

        <li><a href="gem/index.html">The GRASS Extensions Manager (GEM)</a></li>
        <li><a href="misc.html">Misc. commands manual</a></li>
       </ul></td>
    </tr>
    <tr>
      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;Image processing</h3>
       <ul>

        <li><a href="imageryintro.html">Intro image processing</a></li>
        <li><a href="imagery.html">Imagery commands manual</a></li>
      </ul></td>
      <td valign="top" bgcolor="#ddffaa" class="box"><h3>&nbsp;Printing</h3>
       <ul>
        <li><a href="postscript.html">Postscript commands manual</a></li>
       </ul></td>

    </tr>
  </tbody>
</table>

EOF
}

write_html_footer()
{
# $1: unused
# $2: help index url
cat <<EOF
<BR><BR>
<hr>
<p><a href="$2">Help Index</a> | <a href="full_index.html">Full Index</a><br>
&copy; 2003-2009 <a href="http://grass.osgeo.org">GRASS Development Team</a></p>
</body>
</html>
EOF
}

expand_module_class_name()
{
# $1: module class
case "$1" in
    d)    echo "display"        ;;
    db)   echo "database"       ;;
    g)    echo "general"        ;;
    i)    echo "imagery"        ;;
    m)    echo "misc"           ;;
    ps)   echo "postscript"     ;;
    p)    echo "paint"          ;;
    r)    echo "raster"         ;;
    r3)   echo "raster3D"       ;;
    s)    echo "sites"          ;;
    v)    echo "vector"         ;;
    *)    echo "$1"             ;;
esac
}

replace_file()
{
# $1: filename
if [ -f $1 ] && cmp $1.tmp $1 >/dev/null ; then
    rm $1.tmp
else
    mv $1.tmp $1
fi
}

#are we in the tools/ dir?
if [ ! -f build_html_index.sh ] ; then
 echo "ERROR: this script must be run from the tools/ directory" >&2
 exit 1
fi

FULLINDEX=full_index.html

################

#copy over CSS:
cp -f grassdocs.css $HTMLDIR/
mkdir -p $HTMLDIR/nviz/
cp -f grassdocs.css $HTMLDIR/nviz/
chmod a+r $HTMLDIR/grassdocs.css $HTMLDIR/nviz/grassdocs.css
#copy over GRASS logo:
cp -f grass_logo.png $HTMLDIR/
cp -f grass_logo.png $HTMLDIR/nviz/
chmod a+r $HTMLDIR/grass_logo.png $HTMLDIR/nviz/grass_logo.png
if [ "$MACOSX" ] ; then
  cp -f grass_icon.png $HTMLDIR/
  chmod a+r $HTMLDIR/grass_icon.png
fi
#copy over GEM docs:
mkdir -p $HTMLDIR/gem
cp -f $GEMDIR/docs/GEM-Manual/*.html $HTMLDIR/gem/
cp -f $GEMDIR/docs/GEM-Manual/img* $HTMLDIR/gem/
chmod a+r $HTMLDIR/gem/*.html $HTMLDIR/gem/img*

#process all HTML pages:
cd "$HTMLDIR"

#get list of available GRASS modules:
CMDLIST=`ls -1 *.*.html | grep -v "$FULLINDEX" | grep -v index.html | \
  grep -v "\($EXCLUDEHTML\)" | cut -d'.' -f1 | sort -u`
CMDLISTNO=`echo $CMDLIST | wc -w | awk '{print $1}'`

echo "Generating HTML manual pages index (help system)..." >&2

###############################################################################

#begin full index:
(
write_html_header - "GRASS GIS $GRASSVERSION Reference Manual: Full index"

#generate main index of all modules:
echo "Go <a href=\"index.html\">back to help overview</a><BR>"
echo "<BR><h3>Full command index:</h3>"
echo "[ "
k=0
for i in $CMDLIST
do
  k=`expr $k + 1`
  echo -n "<b><a href=\"#$i\">$i.*</a></b>"
  if [ $k -lt $CMDLISTNO ] ; then
     echo -n " | "
  fi
done

echo " ]"
echo "<BR><BR>"
echo ""

cat <<EOF
<table border=0>
<tr><td>&nbsp;&nbsp;<a href="full_index.html#d">d.*</a> </td><td>display commands</td></tr>
<tr><td>&nbsp;&nbsp;<a href="full_index.html#db">db.*</a> </td><td>database commands</td></tr>
<tr><td>&nbsp;&nbsp;<a href="full_index.html#g">g.*</a> </td><td>general commands</td></tr>
<tr><td>&nbsp;&nbsp;<a href="full_index.html#i">i.*</a> </td><td>imagery commands</td></tr>

<tr><td>&nbsp;&nbsp;<a href="full_index.html#m">m.*</a> </td><td>miscellaneous commands</td></tr>
<tr><td>&nbsp;&nbsp;<a href="full_index.html#ps">ps.*</a> </td><td>postscript commands</td></tr>
<tr><td>&nbsp;&nbsp;<a href="full_index.html#r">r.*</a> </td><td>raster commands</td></tr>
<tr><td>&nbsp;&nbsp;<a href="full_index.html#r3">r3.*</a> </td><td>raster3D commands</td></tr>
<tr><td>&nbsp;&nbsp;<a href="full_index.html#v">v.*</a> </td><td>vector commands</td></tr>
<tr><td>&nbsp;&nbsp;<a href="nviz.html">nviz</a> </td><td>visualization suite</td></tr>
<tr><td>&nbsp;&nbsp;<a href="wxGUI.html">wxGUI</a> </td><td>wxPython-based GUI frontend</td></tr>
<tr><td>&nbsp;&nbsp;<a href="xganim.html">xganim</a> </td><td>raster map slideshow</td></tr>
</table>
EOF

#for all module groups:
for i in $CMDLIST
do 
cat <<-EOF
	<a name="$i"></a>
	<BR><BR><h3>$i.* commands:</h3>
	<table>
EOF

  #for all modules:  
  for i in `ls -1 $i.*.html | grep -v "\($EXCLUDEHTML\)"`
  do
    BASENAME=`basename $i .html`
    SHORTDESC="`cat $i | awk '/NAME/,/SYNOPSIS/' | grep '<em>' | cut -d'-' -f2- | sed 's+^ ++g' | grep -vi 'SYNOPSIS' | head -n 1`"
    check_for_desc_override
    echo "<tr><td valign=\"top\"><a href=\"$i\">$BASENAME</a></td> <td>$SHORTDESC</td></tr>"
  done
  echo "</table>"
done

write_html_footer - index.html
) > "$FULLINDEX.tmp"
replace_file "$FULLINDEX"

# done full index

###############################################################################

#next write separate module pages:
#for all module groups:
for k in $CMDLIST
do 
  MODCLASS=`expand_module_class_name $k`
  FILENAME="$MODCLASS.html"

  (
  write_html_header - "GRASS GIS $GRASSVERSION Reference Manual: $MODCLASS"
  echo "Go <a href="index.html">back to help overview</a><BR><BR><BR>"
  echo "<b>$MODCLASS commands:</b>"
  echo "<table>"
  #for all modules:
  for k in `ls -1 $k.*.html | grep -v "\($EXCLUDEHTML\)"`
  do
    BASENAME=`basename $k .html`
    SHORTDESC="`cat $k | awk '/NAME/,/SYNOPSIS/' | grep '<em>' | cut -d'-' -f2- | sed 's+^ ++g' | grep -vi 'SYNOPSIS' | head -n 1`"
    check_for_desc_override
    echo "<tr><td valign=\"top\"><a href=\"$k\">$BASENAME</a></td> <td>$SHORTDESC</td></tr>"
  done
  
  echo "</table>"

  write_html_footer - index.html
  ) > "$FILENAME.tmp"
  replace_file "$FILENAME"
done

###############################################################################

#next write main page:
FILENAME=index.html
(
write_html_header - "GRASS GIS $GRASSVERSION Reference Manual" 1
write_html_cmd_overview 

cat <<EOF
<!-- GEM Extensions StartHTML. Do not delete or change this comment! -->

EOF

write_html_footer - index.html
) > "$FILENAME.tmp"
replace_file "$FILENAME"

###############################################################################

echo "Generated HTML docs in $HTMLDIR/index.html"
echo "----------------------------------------------------------------------"
echo "Following modules are missing the 'description.html' file in src code:"
for i in `find . -name "*.*.html" | sort | grep -v "$FULLINDEX"  | grep -v 'index.html' | grep -v "$EXCLUDEHTML"`
do
  if grep 'DESCRIPTION' $i >/dev/null 2>&1 ; then 
    :
  else
    echo `echo $i | sed 's?./??' | sed 's/.html//'`
  fi
done
echo "----------------------------------------------------------------------"
