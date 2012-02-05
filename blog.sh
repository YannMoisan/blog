#! /bin/bash
# Convention pour le nom de fichier d'un billet : entrynnn-titre-de-la-page
# L'ordre des posts est déduit de l'ordre des fichiers
# Mettre un lien vers BlackBelt
# Formatage auto de la CSS avec VIM
# woorank 35.7 --> 41.7 (icon, lang, rss, sitemap) 
src_dir=src
dst_dir=target

#cd $blog_dir

rm -r $dst_dir
mkdir $dst_dir

csplit $src_dir/page.layout "/<!-- entry -->/" {*}

other_files=(`find $src_dir -name "*.html"|grep -v "entry.*html"`)
o=${#other_files[@]}

    echo "<ul>"  > $src_dir/index.html
    echo "</ul>"  >> $src_dir/index.html
entry_files=(`find $src_dir -name "entry*html"|sort`)
echo nb entry_files:${#entry_files[@]}
l=${#entry_files[@]}
echo l:$l


echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" > $dst_dir/rss.xml
echo "<rss version=\"2.0\">" >> $dst_dir/rss.xml
echo "<channel>" >> $dst_dir/rss.xml 
echo "<title>Yann Moisan</title>" >> $dst_dir/rss.xml
echo "<description>Yann Moisan RSS feed</description>" >> $dst_dir/rss.xml
echo "<link>http://www.yannmoisan.com</link>" >> $dst_dir/rss.xml

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $dst_dir/sitemap.xml
echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">" >> $dst_dir/sitemap.xml
echo "<url><loc>http://www.yannmoisan.com/index.html</loc></url>"  >> $dst_dir/sitemap.xml
echo "<url><loc>http://www.yannmoisan.com/a-propos.html</loc></url>"  >> $dst_dir/sitemap.xml
echo "<url><loc>http://www.yannmoisan.com/cv.html</loc></url>"  >> $dst_dir/sitemap.xml


    for ((i=0;i<l;i++));do
    in=${entry_files[$i]}
    # Pourquoi ./ avec la commande find
    fout=${in#src/entry*-}
    out=$dst_dir/$fout 

#cp src/entry_layout.html src/toto
day=`cat $in|grep day|cut -d= -f2`
month=`cat $in|grep month|cut -d= -f2`
year=`cat $in|grep year|cut -d= -f2`
title=`cat $in|grep title|cut -d= -f2`
echo "$day/$month/$year:$title"

   #title=`awk 'BEGIN{ RS="</h2>"}{gsub(/.*<h2 class="entry-title">/,"")}1{print $RS;exit}' $in`
    echo Processing entry $((i+1))/$l : in=$in out=$out title=$title

    echo ${entry_files[$i]} >> $dst_dir/menu.xml
    cat xx00 > $out

    echo "<item>"  >> $dst_dir/rss.xml
    echo "<title>$title</title>"  >> $dst_dir/rss.xml
    echo "<description>$title</description>"  >> $dst_dir/rss.xml
    echo "<link>http://www.yannmoisan.com/$fout</link>"  >> $dst_dir/rss.xml
    echo "<guid>http://www.yannmoisan.com/$fout</guid>"  >> $dst_dir/rss.xml
    echo "</item>"  >> $dst_dir/rss.xml

    echo "<url><loc>http://www.yannmoisan.com/$fout</loc></url>"  >> $dst_dir/sitemap.xml

    #echo "<li><span id=\"time\">$day/$month/$year</span><a href=\"$fout\">$title</a></li>"  >> $src_dir/index.html
    sed -i "2i<li><span id=\"time\">$day/$month/$year</span><a href=\"$fout\">$title</a></li>"  $src_dir/index.html


    echo "<ul class=\"pager\">"  >> $out
    if [ $i -eq 0 ];then
        prev="first"
    else
        prev=${entry_files[$i-1]#src/entry*-}
        echo "<li class=\"previous\"><a href=\"$prev\">Billet précédent</a></li>" >> $out
    fi

    if [ $i -eq $((l-1)) ];then
        next="last"
    else
        next=${entry_files[$i+1]#src/entry*-}
        echo "<li class=\"next\"><a href=\"$next\">Billet suivant</a></li>" >> $out
    fi


    echo "</ul>"  >> $out

cat src/entry.layout >> $out
tail -n +6 $in > $out.filtered
sed -i "s/<!-- day -->/$day/" $out
sed -i "s/<!-- month -->/$month/" $out
sed -i "s/<!-- year -->/$year/" $out
sed -i "s/<!-- title -->/$title/" $out
sed -i "/<!-- content -->/r $out.filtered" $out
rm $out.filtered

    #cat ${entry_files[$i]} >> $out
    cat xx02 >> $out 

    sed -i "s/<!-- title -->/$title/" $out
done

echo "</channel>" >> $dst_dir/rss.xml
echo "</rss>" >> $dst_dir/rss.xml

echo "</urlset>"  >> $dst_dir/sitemap.xml

# TODO:Creer une méthode qui prend un tableau de fichiers et un mode : isEntry
for file in "${other_files[@]}";do
    echo Processing:$file

    title=`awk 'BEGIN{ RS="</h2>"}{gsub(/.*<h2 class="entry-title">/,"")}1{print $RS;exit}' $file`
    echo ${file} >> $dst_dir/menu.xml
    dst_file=$dst_dir/${file#src/}
    cat xx00 > $dst_file

    cat ${file} >> $dst_file
    cat xx02 >> $dst_file

    sed -i "s/<!-- title -->/$title/" $dst_file
done
cp $src_dir/style.css $dst_dir/style.css
cp $src_dir/favicon.ico $dst_dir/favicon.ico
cp $src_dir/belt3_L.gif $dst_dir/belt3_L.gif
