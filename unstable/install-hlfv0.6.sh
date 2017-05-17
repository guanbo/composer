(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ʚY �[o�0�yxᥐ�P�21�BJ�AI`�S<r�si���>;e����R�i����s|αq{q��0�`k繵w�'t�zzW|�NE��	�����{5^�m����L��c+E�y�k��������Eq�lI x�[Nm� �5��fB�Bg1�`�0��9��u��v�|���!�)����0�q�2 M���W�^��)�A?>����F�tm94�s@~�lp�ȣ~���H�z��H�h�=��b!�o�����M�6�hkS[�h�M��J��&�sY���h�ɺ>X�H6�q\�A���D���df�=Iǥ�p�sN��[�)�x<��ME^�J$�,�����$y���)�
�i��\�i�荷���F��p�M��r?TI4UQȺb�fiq':��F�xz��-	WF�w���5D��r]m@��ȅ0W�2����_: �ă�٪�'������g������n���w*[����%ziT-0����V4�P��U�Tq��n'c	|�; �qx�n��7s< Fu�� ����CK��-�Qsy�p`dc�OP��11�6R����b"��\vn�ni�z�L�m�̵�1tHV��F�I�YܠP��M�ӭqh�|���	h/��c�@e-LIwɪR/V�-t����R,�|I��4�� yν=_�K̛
n9�
�5���n����w��zq|������`0��`0��`0��`�M~ gϭ (  