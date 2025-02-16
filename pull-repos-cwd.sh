for dir in */ 
do
	cd $PWD/$dir;
	if git rev-parse --git-dir > /dev/null 2>&1; then
	echo $PWD/$dir;
	git pull;
	cd ..;
	else
		cd ..;
	fi;
done
cd ..;
