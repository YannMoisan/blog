#! /bin/bash
# Convention pour le nom de fichier d'un billet : entrynnn-titre-de-la-page
# L'ordre des posts est déduit de l'ordre des fichiers
# Mettre un lien vers BlackBelt
# Formatage auto de la CSS avec VIM
# woorank 35.7 --> 41.7 (icon, lang, rss, sitemap) 
blog_dir=src

cd $blog_dir

rm -r target
mkdir target

csplit template.html "/<!-- entry -->/" {*}

other_files=(`find . -name "*.html"|grep -v "entry.*html"`)
o=${#other_files[@]}

entry_files=(`find . -name "e*"|sort`)
echo nb entry_files:${#entry_files[@]}
l=${#entry_files[@]}
echo l:$l

# TODO:Creer une méthode qui prend un tableau de fichiers et un mode : isEntry
for ((i=0;i<o;i++));do
  echo Processing:${other_files[$i]}
  
  title=`awk 'BEGIN{ RS="</h2>"}{gsub(/.*<h2 class="entry-title">/,"")}1{print $RS;exit}' ${other_files[$i]}`
  echo ${other_files[$i]} >> target/menu.xml
  cat xx00 > target/${other_files[$i]}
  
  cat ${other_files[$i]} >> target/${other_files[$i]}
  cat xx02 >> target/${other_files[$i]}

  sed -i "s/<!-- title -->/$title/" target/${other_files[$i]}
done

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" > target/rss.xml
echo "<rss version=\"2.0\">" >> target/rss.xml
echo "<channel>" >> target/rss.xml 
echo "<title>Yann Moisan</title>" >> target/rss.xml
echo "<description>Yann Moisan RSS feed</description>" >> target/rss.xml
echo "<link>http://www.yannmoisan.com</link>" >> target/rss.xml

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > target/sitemap.xml
echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">" >> target/sitemap.xml
echo "<url><loc>http://www.yannmoisan.com/index.html</loc></url>"  >> target/sitemap.xml
echo "<url><loc>http://www.yannmoisan.com/a-propos.html</loc></url>"  >> target/sitemap.xml
echo "<url><loc>http://www.yannmoisan.com/cv.html</loc></url>"  >> target/sitemap.xml

for ((i=0;i<l;i++));do
  in=${entry_files[$i]}
  # Pourquoi ./ avec la commande find
  fout=${in#./entry*-}
  out=target/$fout 
  
  title=`awk 'BEGIN{ RS="</h2>"}{gsub(/.*<h2 class="entry-title">/,"")}1{print $RS;exit}' $in`
  echo Processing entry $((i+1))/$l : in=$in out=$out title=$title

  echo ${entry_files[$i]} >> target/menu.xml
  cat xx00 > $out
 
  echo "<item>"  >> target/rss.xml
   echo "<title>$title</title>"  >> target/rss.xml
   echo "<description>$title</description>"  >> target/rss.xml
   echo "<link>http://www.yannmoisan.com/$fout</link>"  >> target/rss.xml
   echo "<guid>http://www.yannmoisan.com/$fout</guid>"  >> target/rss.xml
   echo "</item>"  >> target/rss.xml

echo "<url><loc>http://www.yannmoisan.com/$fout</loc></url>"  >> target/sitemap.xml


  echo "<p class=\"nav\">"  >> $out
  if [ $i -eq 0 ];then
    prev="first"
  else
    prev=${entry_files[$i-1]#./entry*-}
    echo "<a href=\"$prev\">Billet précédent</a>" >> $out
    echo "<span>-</span>"  >> $out
  fi
  
  if [ $i -eq $((l-1)) ];then
    next="last"
  else
    next=${entry_files[$i+1]#./entry*-}
    echo "<a href=\"$next\">Billet suivant</a>" >> $out
  fi

  
  echo "</p>"  >> $out

  cat ${entry_files[$i]} >> $out
  cat xx02 >> $out 
  
  sed -i "s/<!-- title -->/$title/" $out
done

echo "</channel>" >> target/rss.xml
echo "</rss>" >> target/rss.xml

echo "</urlset>"  >> target/sitemap.xml

cp style.css target/style.css
cp favicon.ico target/favicon.ico
cp belt3_L.gif target/belt3_L.gif
cp $out target/index.html
