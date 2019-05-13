#!/bin/bash

campus=$(basename $PWD)
# Maneira melhor de carregar os dados do horário
#source <(grep = horario/horario.ini)
# Fonte: https://stackoverflow.com/questions/6318809/how-do-i-grab-an-ini-value-within-a-shell-script


decorar(){
  titulo=$1
  caracter=$2
  [ $# != 2 ] && return
  n=${#titulo}
  decorador=$(printf -- "${caracter}%.0s" $(seq 1 ${n}))
  cat << EOF

$titulo
$decorador

EOF
}

principal(){

for categoria in professor sala turma; do
    
    rm -rf ${categoria} rst/${categoria} rst/_static/img/${categoria} dropbox/${categoria}

    mkdir -v ${categoria}
    mkdir -vp rst/${categoria}
    mkdir -vp rst/_static/img/${categoria}/
    mkdir -vp dropbox/${categoria}

    pdfseparate ${categoria}.pdf ${categoria}/${categoria}-%d.pdf
    cd ${categoria}
    for f in *.pdf; do
        pdftotext -layout $f
        titulo=$(head -1 ${f%.pdf}.txt | sed 's/^ *//;s/ *$//;s/^Professor //')
	      slug=$(slugify $titulo)
        echo "${slug}:${titulo}" > index.csv
	      mv -v $f ${slug}.pdf
        mv -v ${f%.pdf}.txt ${slug}.txt
	
        inkscape \
              --without-gui \
              --file=${slug}.pdf \
              --export-plain-svg=${slug}.svg
        
        cp ${slug}.svg -v ../rst/_static/img/${categoria}/
        cp ${slug}.pdf -v ../dropbox/${categoria}/

        RST_DIR="../rst/${categoria}/${slug}/"
        mkdir -vp $RST_DIR
        cat << EOF >> ${RST_DIR}/index.rst
.. _${slug}:

${titulo}
===========

.. figure:: ../../_static/img/${categoria}/${slug}.svg
   :alt: ${titulo}


EOF

if [[ $categoria =~ ^(professor|sala)$ ]]; then
  cat << EOF >> ${RST_DIR}/index.rst

Turmas
------


EOF
fi

    done
    cd -

    # Gerar rst/${categoria}/index.rst
    cat << FIM > rst/${categoria}/index.rst
Horário de ${categoria}
==========================

.. toctree::
   :maxdepth: 1

FIM
    
    # Ordenar os arquivos em rst/${categoria}/index.rst
    cd rst/${categoria}
    ls */index.rst | sort | awk '{print "   "$1}' >> index.rst
    cd -

done

map_prof_turma
map_lab_turma
gerar_html

}


map_lab_turma(){
    # Mapeamento de laboratórios e salas para turmas
    cat turma/index.csv | while IFS=: read slug id _; do 
      labturma=$(cd rst/_static/img/sala/; grep -l $id *.svg | sed 's/\.svg$//');
      idxturma=rst/turma/${slug}/index.rst
      cat << EOF >> $idxturma

Laboratórios e salas
--------------------

EOF

      for p in $labturma; do
        idxlab=rst/sala/${p}/index.rst
        echo "* :doc:\`/sala/${p}/index\`" >> $idxturma
        echo "* :doc:\`/turma/${slug}/index\`" >> $idxlab
      done
    done
}

map_prof_turma() {
    # Mapeamento de professores para turmas
    cat turma/index.csv | while IFS=: read slug id _; do 
      profturma=$(cd rst/_static/img/professor/; grep -l $id *.svg | sed 's/\.svg$//');
      idxturma=rst/turma/${slug}/index.rst
      cat << EOF >> $idxturma

Professores
-----------

EOF

      for p in $profturma; do
        idxprof=rst/professor/${p}/index.rst
        echo "* :doc:\`/professor/${p}/index\`" >> $idxturma
        echo "* :doc:\`/turma/${slug}/index\`" >> $idxprof
      done
    done
}

gerar_html(){
  # Gerar páginas HTML e limpar links para "index.html"
  cd rst
  make clean
  make html
  find _build/html/ -name index.html | xargs sed -i 's@/index.html@/@'
  cd -
}

principal