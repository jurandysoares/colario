#!/bin/bash

if [[ $# -ne 2 ]]; then
	return 1
fi

for dt_dir in $@; 
do  
  echo $dt_dir
  cd $dt_dir

  for categoria in professor sala turma; do
      mkdir -v ${categoria}
      pdfseparate ${categoria}.pdf ${categoria}/${categoria}-%d.pdf
      cd ${categoria}

      for f in *.pdf; do
          pdftotext -layout $f
          titulo=$(head -1 ${f%.pdf}.txt | sed 's/^ *//;s/ *$//;s/^Professor //')
      done
 
      slug=$(slugify "$titulo")
      mv -v $f ${slug}.pdf
      mv -v ${f%.pdf}.txt ${slug}.txt
  done
  cd -
done    
