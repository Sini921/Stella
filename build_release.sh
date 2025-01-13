if grep -q "THEOS_PACKAGE_SCHEME" Makefile; then
    sed -i '' '/THEOS_PACKAGE_SCHEME/d' Makefile
    echo "Removed 'THEOS_PACKAGE_SCHEME' from Makefile"
fi

if grep -q "THEOS_DEVICE_IP" Makefile; then
    sed -i '' '/THEOS_DEVICE_IP/d' Makefile
    echo "Removed 'THEOS_DEVICE_IP' from Makefile"
fi

rm -rf ./packages
rm -rf ./.theos

echo "Building rootful package"
make clean > /dev/null
make clean package FINALPACKAGE=1 > /dev/null

echo "Building rootless package"
make clean > /dev/null
make clean package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless > /dev/null

echo "Finished building packages"
exit 0