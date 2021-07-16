echo decoding sql...
mkdir -p /flyway/sql
find /flyway/sql_base64 -name "*.sql.base64" -type l | while read line; do
if [ -f $line ]; then
   filename=$(basename -- "$line")
   filename="${filename%.*}"
   echo "file name is ${filename}"
   input="/flyway/sql_base64/${filename}.base64"
   output="/flyway/sql/${filename}"
   base64 -d ${input} > ${output}
fi
done


echo ==================