#!/bin/bash

#Direccion del .jar de weka
CLASSPATH="./../../weka-3-8-3/weka.jar"

#Variables clasificacion
JRip="weka.classifiers.rules.JRip"
ZEROR="weka.classifiers.rules.ZeroR"

#Variables Seleccion Atributos
ATRIB="weka.filters.supervised.attribute.AttributeSelection"
METHOD="weka.attributeSelection.WrapperSubsetEval"
CLASSIFIER="weka.attributeSelection.GreedyStepwise"

#Creacion nombre archivo de salida
FILE_OUT="../Resultados/JRip/Resultado_$(echo $1 | sed 's/\./\//g' | cut -d "/" -f 7 ).txt"

#Impresion de la informacion
#cut = 1,2 Titulo; 14 Precision; 24 FMeasure
get_acc_JRip() {
    cat Prov.txt | grep "Correctly Classified Instances" >> ./$FILE_OUT
    cat Prov.txt | grep "Number of Rules" >> ./$FILE_OUT
    cat Prov.txt | grep "Weighted Avg" | cut -d " " -f 1,2,14,24 >> ./$FILE_OUT
    echo -e "\n" >> ./$FILE_OUT
}

show_atrib() {
    cat sel.arff | grep "@attribute" | cut -d " " -f 2 >> ./$FILE_OUT
}
#Ejecucion de los algoritmos

mkdir -p ./../Resultados/JRip/

#ZeroR
echo "Default zeroR:" > ./$FILE_OUT
java -classpath $CLASSPATH $ZEROR -t $1 -x 5| grep "Correctly Classified Instances" >> ./$FILE_OUT
echo -e "\n" >> ./$FILE_OUT

#JRip Con CrossValidation de 5
#Default
echo "Default c4.5:" >> ./$FILE_OUT
java -classpath $CLASSPATH $JRip -t $1 -F 5  > ./Prov.txt
$(get_acc_JRip)

#Seleccion de atributos
java -classpath $CLASSPATH $ATRIB -E "$METHOD -B $JRip -F 5" -S "$CLASSIFIER" -i $1 > ./sel.arff
echo -e "Atributos seleccionados: \n" >> ./$FILE_OUT
$(show_atrib)
echo -e "\n" >> ./$FILE_OUT

#Default tras seleccion
echo "Default c4.5:" >> ./$FILE_OUT
java -classpath $CLASSPATH $JRip -t ./sel.arff -F 5  > ./Prov.txt
$(get_acc_JRip)


rm ./Prov.txt
rm ./sel.arff

cat ./$FILE_OUT
