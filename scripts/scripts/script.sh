source createMasterDomain.sh
source createRegistory.sh
source createReverseZone.sh
source removeMasterDomain.sh
source removeReverseZone.sh
source configNFS.sh

read -p "Escole uma das opções digitando o numero: 
1. Criar uma zona master
2. Criar um registo para um dominio já existe
3. Criar uma zona reverse para um dominio já existe
4. Remover uma zona master
5. Remover uma zona reverse
6. configurar NFS
10. Sair
" input

case $input in
  1)
    createMasterZone
;;
  2)
    createRegistory
;;
  3)
    create_reverse_zone
;;
  4)
    removeMasterZone
;;
  5)
    removeReverseZone
;;
  6)
    createNFS
;;
  10)
    exit
;;
  *)
    echo -n "seleção invalida"
;;

esac
