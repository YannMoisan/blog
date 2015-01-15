#! /bin/bash
# Convention pour le nom de fichier d'un billet : entry-yyyymmdd-titre-de-la-page
# L'ordre des posts est déduit de l'ordre des fichiers
# Mettre un lien vers BlackBelt
# Formatage auto de la CSS avec VIM
# woorank 35.7 --> 41.7 (icon, lang, rss, sitemap) 
src_dir=src
dst_dir=target

bp=#b
ep=#e

short_months=("Jan" "Fév" "Mar" "Avr" "Mai" "Jun" "Jul" "Aoû" "Sep" "Oct" "Nov" "Déc")
long_months=("janvier" "février" "mars" "avril" "mai" "juin" "juillet" "août" "septembre" "octobre" "novembre" "décembre")

appendHeader() {
    sed -n 1,/$bp/p $1 | sed \$d >> $2
}

appendContent() {
    sed -n /$bp/,/$ep/p $1 | sed 1d | sed \$d >> $2
}

appendFooter() {
    sed -n /$ep/,\$p $1 | sed 1d >> $2
}

rm -r $dst_dir
mkdir $dst_dir

csplit $src_dir/page.layout "/<!-- entry -->/" {*}

other_files=(`find $src_dir -name "*.html"|grep -v "entry.*html"`)
o=${#other_files[@]}

entry_files=(`find $src_dir -name "entry*html"|sort`)
echo nb entry_files:${#entry_files[@]}
l=${#entry_files[@]}

appendHeader $src_dir/rss.layout $dst_dir/rss.xml
appendHeader $src_dir/sitemap.layout $dst_dir/sitemap.xml
appendHeader $src_dir/index.layout $dst_dir/index.html

for ((i=0;i<l;i++));do
    in=${entry_files[$i]}
    fout=${in#src/entry*-*-}
    out=$dst_dir/$fout 

    bin=$(basename $in)
    day=${bin:12:2}
    month=${bin:10:2}
    year=${bin:6:4}
    title=`cat $in|grep '\$title'|cut -d= -f2`
    description=`cat $in|grep '\$description'|cut -d= -f2`
    echo "description:$description"    
    echo Processing entry $((i+1))/$l : in=$in

    cat xx00 > $out

    # Sitemap
    appendContent $src_dir/sitemap.layout $dst_dir/sitemap.xml
    sed -i "s/\$fout/$fout/" $dst_dir/sitemap.xml
    
    # index
#    appendContent $src_dir/index.layout $dst_dir/index.html
#    sed -i "s/\$fout/$fout/" $dst_dir/index.html
#    sed -i "s/\$day/$day/" $dst_dir/index.html
#    sed -i "s/\$month/$month/" $dst_dir/index.html
#    sed -i "s/\$year/$year/" $dst_dir/index.html
#    sed -i "s/\$title/$title/" $dst_dir/index.html

    if [ $i -ne 0 ];then
        prev=${entry_files[$i-1]#src/entry*-*-}
        echo "<a class=\"previous\" href=\"$prev\">←</a></li>" >> $out
    fi

    if [ $i -ne $((l-1)) ];then
        next=${entry_files[$i+1]#src/entry*-*-}
        echo "<a class=\"next\" href=\"$next\">→</a></li>" >> $out
    fi
    echo "</ul>"  >> $out
    echo "</nav>"  >> $out

    cat src/entry.layout >> $out
    tail -n +4 $in > $out.filtered
    month_index=`expr $month - 1`
    sed -i "s/<!-- day -->/$day/" $out
    sed -i "s/<!-- month -->/${long_months[$month_index]}/" $out
    sed -i "s/<!-- year -->/$year/" $out
    sed -i "s/<!-- title -->/$title/" $out
    sed -i "s/<!-- description -->/$description/" $out
    sed -i "/<!-- content -->/r $out.filtered" $out
    rm $out.filtered

    cat xx02 >> $out 
done


#index in reverse order, lot of duplicate code with above code
for ((i=l-1;i>=0;i--));do
    in=${entry_files[$i]}
    fout=${in#src/entry*-*-}
    out=$dst_dir/$fout 

    bin=$(basename $in)
    day=${bin:12:2}
    month=${bin:10:2}
    year=${bin:6:4}
    title=`cat $in|grep '\$title'|cut -d= -f2`
    description=`cat $in|grep '\$description'|cut -d= -f2`
    echo "description:$description"    
    echo Processing entry $((i+1))/$l : in=$in

    # index
    appendContent $src_dir/index.layout $dst_dir/index.html
    sed -i "s/\$fout/$fout/" $dst_dir/index.html
    sed -i "s/\$day/$day/" $dst_dir/index.html

    # RSS
    appendContent $src_dir/rss.layout $dst_dir/rss.xml
    sed -i "s/\$title/$title/" $dst_dir/rss.xml
    sed -i "s/\$fout/$fout/" $dst_dir/rss.xml
    pubDate=`date -R -d $year$month$day`
    sed -i "s/\$date/$pubDate/" $dst_dir/rss.xml
    
    
    month_index=`expr $month - 1`
    month_name=${short_months[$month_index]}
    echo $month
    echo `expr $month - 1`
    echo $month_name
    sed -i "s/\$month/$month_name/" $dst_dir/index.html
    sed -i "s/\$year/$year/" $dst_dir/index.html
    sed -i "s/\$title/$title/" $dst_dir/index.html

done

appendFooter $src_dir/rss.layout $dst_dir/rss.xml
appendFooter $src_dir/sitemap.layout $dst_dir/sitemap.xml
appendFooter $src_dir/index.layout $dst_dir/index.html

# TODO:Creer une méthode qui prend un tableau de fichiers et un mode : isEntry
for file in "${other_files[@]}";do
    echo Processing:$file

    title=`awk 'BEGIN{ RS="</h2>"}{gsub(/.*<h2 class="entry-title">/,"")}1{print $RS;exit}' $file`
    dst_file=$dst_dir/${file#src/}
    cat xx00 > $dst_file

    cat ${file} >> $dst_file
    cat xx02 >> $dst_file

    sed -i "s/<!-- title -->/$title/" $dst_file
done
cat xx00 > $dst_dir/index2.html
cat $dst_dir/index.html >> $dst_dir/index2.html
cat xx02 >> $dst_dir/index2.html
mv $dst_dir/index2.html $dst_dir/index.html
sed -i "s/<!-- title -->/Liste des billets/" $dst_dir/index.html

# copy static resources : images, styles, …
for f in `find src/* -not -name "*.html" -not -name "*.layout"`
do
    cp $f $dst_dir
done
cp -r src/font $dst_dir
