#!/bin/bash

#Direccion del .jar de weka
CLASSPATH="./../../weka-3-8-3/weka.jar"

#Variables clasificacion
BAGGING="weka.classifiers.meta.Bagging"

CLASSIFIERS=("weka.classifiers.trees.J48"
                "weka.classifiers.rules.JRip"
                "weka.classifiers.functions.MultilayerPerceptron"
                "weka.classifiers.bayes.NaiveBayes"
                "weka.classifiers.trees.REPTree"
            )

echo "Got $# params"

while (( "$#" )); do
    #Creacion nombre archivo de salida
    FILE_OUT="../Resultados/Bagging/Resultado_$(echo $1 | sed 's/\./\//g' | cut -d "/" -f 7 ).md"

    #Impresion de la informacion
    get_acc_bagging() {
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Correctly Classified Instances" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Weighted Avg" | awk '{print $1, $2, $5, $7}' >> ./$FILE_OUT
        echo -e "---- \n" >> ./$FILE_OUT
    }

    #Ejecucion de los algoritmos

    mkdir -p ./../Resultados/Bagging/

    echo "# J48 bag:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $BAGGING -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[0]} -- -M 2 -C 0.25 > ./Prov.txt
    $(get_acc_bagging)

    echo "# JRip bag" >> ./$FILE_OUT
    java -classpath $CLASSPATH $BAGGING -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[1]} > ./Prov.txt
    $(get_acc_bagging)

    echo "# NN bag" >> ./$FILE_OUT
    java -classpath $CLASSPATH $BAGGING -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[2]} > ./Prov.txt
    $(get_acc_bagging)

    echo "# Naive bag:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $BAGGING -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[3]} > ./Prov.txt
    $(get_acc_bagging)

    echo "# RepTree bag:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $BAGGING -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[4]} > ./Prov.txt
    $(get_acc_bagging)

    rm ./Prov.txt

    cat ./$FILE_OUT
    shift
done