#!/bin/sh

. ./environ.sh
echo "[+] generating standalone jar."
lein uberjar

target="$1"
jarfile="$(ls -1 *standalone* | head -n 1)"
timestamp=$(date +'%s')
deploy_dir=$(basename $(pwd))

echo "[+] deploying $jarfile to $target..."
echo "[+] building tarball..."
mkdir $deploy_dir
cp *standalone*.jar $deploy_dir
cp environ.sh $deploy_dir
printf "#!/bin/sh\n\n. ./environ.sh\njava -jar $jarfile \$*\n" > \
    $deploy_dir/run.sh
chmod +x $deploy_dir/run.sh
echo $timestamp > $deploy_dir/TIMESTAMP 
tar czvf $deploy_dir-deploy-$timestamp.tgz $deploy_dir
if [ ! -e $deploy_dir-deploy-$timestamp.tgz ]; then
    echo "[!] failed to create tarball"
    exit 1
fi
echo "[+] tarball $deploy_dir-deploy-$timestamp.tgz created..."
echo "[+] pushing to $target"
scp $deploy_dir-deploy-$timestamp.tgz $target:deploy/
echo "[+] unpacking on $target"
ssh $target "cd deploy && tar xzf $deploy_dir-deploy-$timestamp.tgz "
ssh $target "rm deploy/$deploy_dir-deploy-$timestamp.tgz"
echo "[+] target unpacked to $target:deploy/$deploy_dir/"
echo "[+] cleaning up..."
rm -r $deploy_dir
rm -r $deploy_dir-deploy-$timestamp.tgz
lein clean
echo "[+] complete!"
