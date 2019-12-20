#!/bin/bash

#Direccion del .jar de weka
CLASSPATH="./../../weka-3-8-3/weka.jar"

#Variables clasificacion
ADA="weka.classifiers.meta.AdaBoostM1"

CLASSIFIERS=("weka.classifiers.trees.J48"
                "weka.classifiers.rules.JRip"
                "weka.classifiers.functions.MultilayerPerceptron"
                "weka.classifiers.bayes.NaiveBayes"
                "weka.classifiers.trees.REPTree"
            )

echo "Got $# params"

while (( "$#" )); do
    #Creacion nombre archivo de salida
    FILE_OUT="../Resultados/Ada/Resultado_$(echo $1 | sed 's/\./\//g' | cut -d "/" -f 7 ).md"

    #Impresion de la informacion
    get_acc_ada() {
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Correctly Classified Instances" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Weighted Avg" | awk '{print $1, $2, $5, $7}' >> ./$FILE_OUT
        echo -e "---- \n" >> ./$FILE_OUT
    }

    #Ejecucion de los algoritmos

    mkdir -p ./../Resultados/Ada/

    echo "# J48 bag:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $ADA -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[0]} -- -M 2 -C 0.25 > ./Prov.txt
    $(get_acc_ada)

    echo "# JRip bag" >> ./$FILE_OUT
    java -classpath $CLASSPATH $ADA -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[1]} > ./Prov.txt
    $(get_acc_ada)

    echo "# NN bag" >> ./$FILE_OUT
    java -classpath $CLASSPATH $ADA -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[2]} > ./Prov.txt
    $(get_acc_ada)

    echo "# Naive bag:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $ADA -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[3]} > ./Prov.txt
    $(get_acc_ada)

    echo "# RepTree bag:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $ADA -P 100 -S 1 -I 10 -t $1 -x 5 -W ${CLASSIFIERS[4]} > ./Prov.txt
    $(get_acc_ada)

    rm ./Prov.txt

    cat ./$FILE_OUT
    shift
done