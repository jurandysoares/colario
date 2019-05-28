#!/bin/bash

if [[ $# -ne 1 ]]; then
	return 1
fi

campus=$1
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

atualiza_horario(){

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
	SIGLA_ARQ="../sigla/${categoria}.csv"
	if [ -f "${SIGLA_ARQ}" ]; then
		sigla=$(awk -F, -v titulo="$titulo" '$1 == titulo {print $2}' ${SIGLA_ARQ})
		slug=$(echo $sigla | slugify)
	else
        	slug=$(echo $titulo | slugify)
	fi
        echo "${slug}:${titulo}" >> index.csv
        mv -v $f ${slug}.pdf
        mv -v ${f%.pdf}.txt ${slug}.txt
	
        inkscape \
              --without-gui \
              --file=${slug}.pdf \
              --export-plain-svg=${slug}.svg  2> /dev/null
        
        cp ${slug}.svg -v ../rst/_static/img/${categoria}/
        cp ${slug}.pdf -v ../dropbox/${categoria}/

        RST_DIR="../rst/${categoria}/${slug}/"
        mkdir -vp $RST_DIR
        titulo_decorado=$(decorar "${titulo}" "=")
        cat << EOF >> ${RST_DIR}/index.rst
.. _${slug}:

${titulo_decorado}

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
    cat turma/index.csv | while IFS=: read slug id; do

      labturma=$(cd sala/; grep -liw $slug *.txt | sed 's/\.txt$//');
      idxturma=rst/turma/${slug}/index.rst
      cat << EOF >> $idxturma

Labs. e salas desta turma
--------------------------

EOF

      for s in $labturma; do
        idxlab=rst/sala/${s}/index.rst
        echo "* :ref:\`${s}\`" | tee -a $idxturma
        echo "* :ref:\`${slug}\`" | tee -a $idxlab
      done
    done
}

map_prof_turma() {
    # Mapeamento de professores para turmas
    cat turma/index.csv | while IFS=: read slug id; do

      profturma=$(cd professor/; grep -liw $slug *.txt | sed 's/\.txt$//');
      idxturma=rst/turma/${slug}/index.rst
      cat << EOF >> $idxturma

Professores desta turma
-----------------------

EOF

      for p in $profturma; do
        idxprof=rst/professor/${p}/index.rst
        echo "* :ref:\`${p}\`" | tee -a $idxturma
        echo "* :ref:\`${slug}\`" | tee -a $idxprof
      done
    done
}

gerar_html(){
  # Gerar páginas HTML e limpar links para "index.html"
  cd rst
  . /home/jurandy/esfinge/bin/activate
  make clean
  make html
  find _build/html/ -name index.html | xargs sed -i 's@/index.html@/@'
  cd -
}

principal(){
   	cd /var/lib/colario/${campus} || exit
	cd horario || exit
	git pull
	MOD_TURMA=$(stat -c%Y turma.pdf)
	MOD_SALA=$(stat -c%Y sala.pdf)
	MOD_PROFESSOR=$(stat -c%Y professor.pdf)
	MOD_INDEX=$(stat -c%Y /var/www/html/horario/${campus}/index.html)
	cd -

	if [ "$MOD_INDEX" -lt "$MOD_TURMA" -o  "$MOD_INDEX" -lt "$MOD_SALA" -o "$MOD_INDEX" -lt "$MOD_PROFESSOR" ]; then
		  atualiza_horario
		  DATAHORA=$(date +'%Y-%m-%d-%H-%M')
		  mv /var/www/html/horario/${campus}{,-até-${DATAHORA}}
		  mv rst/_build/html /var/www/html/horario/${campus}
	fi
}

principal
