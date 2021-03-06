#!/bin/bash

#Direccion del .jar de weka
CLASSPATH="./../../weka-3-8-3/weka.jar"

#Variables clasificacion
J48="weka.classifiers.trees.J48"
ZEROR="weka.classifiers.rules.ZeroR"

#Variables Seleccion Atributos
ATRIB="weka.filters.supervised.attribute.AttributeSelection"
METHOD="weka.attributeSelection.WrapperSubsetEval"
CLASSIFIER="weka.attributeSelection.GreedyStepwise"

echo "Got $# params"

while (( "$#" )); do
    #Creacion nombre archivo de salida
    FILE_OUT="../Resultados/J48/Resultado_$(echo $1 | sed 's/\./\//g' | cut -d "/" -f 7 ).md"

    #Impresion de la informacion
    #cut = 1,2 Titulo; 14 Precision; 24 FMeasure
    get_acc_j48() {
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Correctly Classified Instances" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Number of Leaves" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Size of the tree" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Weighted Avg" | awk '{print $1, $2, $5, $7}' >> ./$FILE_OUT
        echo -e "---- \n" >> ./$FILE_OUT
    }

    show_atrib() {
        cat sel.arff | grep "@attribute" | cut -d " " -f 2 >> ./$FILE_OUT
    }
    #Ejecucion de los algoritmos

    mkdir -p ./../Resultados/J48/

    #Seleccion de atributos
    java -classpath $CLASSPATH $ATRIB -E "$METHOD -B $J48 -F 5 -T 0.01 -R 1" -S "$CLASSIFIER" -i $1 > ./sel.arff
    echo -e "#Atributos seleccionados: \n" > ./$FILE_OUT
    $(show_atrib)
    echo -e "\n" >> ./$FILE_OUT

    #Default tras seleccion
    echo "#Default c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 2 -C 0.25 > ./Prov.txt
    $(get_acc_j48)

    #Numero minimo de atributos por hoja = 3
    echo "#Min num Obj = 3 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 3 -C 0.25 > ./Prov.txt
    $(get_acc_j48)

    #Numero minimo de atributos por hoja = 4
    echo "#Min num Obj = 4 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 4 -C 0.25 > ./Prov.txt
    $(get_acc_j48)

    #Numero minimo de atributos por hoja = 5
    echo "#Min num Obj = 5 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 5 -C 0.25 > ./Prov.txt
    $(get_acc_j48)

   #Tendencia a la poda alta
    echo "#Confidence factor 0.1 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 2 -C 0.1 > ./Prov.txt
    $(get_acc_j48)

    #Tendencia a la poda alta + 3 hojas
    echo "#Confidence factor 0.1  min 3 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 3 -C 0.1 > ./Prov.txt
    $(get_acc_j48)

        #Tendencia a la poda alta + 3 hojas
    echo "#Confidence factor 0.1  min 4 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 4 -C 0.1 > ./Prov.txt
    $(get_acc_j48)

        #Tendencia a la poda alta + 3 hojas
    echo "#Confidence factor 0.1  min 5 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 5 -C 0.1 > ./Prov.txt
    $(get_acc_j48)

    #Tendencia a la poda media
    echo "#Confidence factor 0.5 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 2 -C 0.5 > ./Prov.txt
    $(get_acc_j48)

        #Tendencia a la poda baja + 3 hojas
    echo "#Confidence factor 0.5  min 3 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 3 -C 0.5 > ./Prov.txt
    $(get_acc_j48)

        #Tendencia a la poda baja + 3 hojas
    echo "#Confidence factor 0.5  min 4 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 4 -C 0.5 > ./Prov.txt
    $(get_acc_j48)

    #Tendencia a la poda baja + 3 hojas
    echo "#Confidence factor 0.5  min 5 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 5 -C 0.5 > ./Prov.txt
    $(get_acc_j48)

    #Tendencia a la poda baja
    echo "#Confidence factor 0.9 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 2 -C 0.9 > ./Prov.txt
    $(get_acc_j48)

        #Tendencia a la poda baja + 3 hojas
    echo "#Confidence factor 0.9  min 3 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 3 -C 0.9 > ./Prov.txt
    $(get_acc_j48)

    #Tendencia a la poda baja + 3 hojas
    echo "#Confidence factor 0.9  min 4 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 4 -C 0.9 > ./Prov.txt
    $(get_acc_j48)

    #Tendencia a la poda baja + 3 hojas
    echo "#Confidence factor 0.9  min 5 c4.5:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $J48 -t ./sel.arff -x 5 -M 5 -C 0.9 > ./Prov.txt
    $(get_acc_j48)

    rm ./Prov.txt
    rm ./sel.arff

    cat ./$FILE_OUT
    shift
done