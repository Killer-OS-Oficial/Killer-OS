#!/bin/bash

script_path=$(readlink -f ${0%/*})
work_dir=${script_path}/work/x86_64/airootfs

chrooter(){
   arch-chroot ${work_dir} /bin/bash -c "${1}"
}

echo "==== create settings.sh ===="

cat <<EOF >${work_dir}/settings.sh
reflector -a 12 -l 70 -f 30 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist

## blackarch strap
curl -OL https://blackarch.org/strap.sh
sed -i "s|pgp.mit.edu|keys.gnupg.net|g" strap.sh
chmod +x strap.sh
./strap.sh
rm strap.sh

pacman -Syyuu --noconfirm

sed -i '/User/s/^#\+//' /etc/sddm.conf

Lsb_release() {
    sed -i /etc/lsb-release \
        -e 's,DISTRIB_ID=.*,DISTRIB_ID=Killer-OS,' \
        -e 's,DISTRIB_RELEASE=.*,DISTRIB_RELEASE=Rolling,' \
        -e 's,DISTRIB_CODENAME=.*,DISTRIB_CODENAME=Killer-Hacker-Oficial,' \
        -e 's,DISTRIB_DESCRIPTION=.*,DISTRIB_DESCRIPTION=\"Killer-OS Linux\",'

}

Os_release() {
    sed -i /usr/lib/os-release \
        -e 's,NAME=.*,NAME=\"Killer-OS Linux\",' \
        -e 's,PRETTY_NAME=.*,PRETTY_NAME=\"Killer-OS Linux\",' \
        -e 's,ID=.*,ID=killer-os,' \
        -e 's,ID_LIKE=.*,ID_LIKE=arch,' \
        -e 's,BUILD_ID=.*,BUILD_ID=rolling,' \
        -e 's,HOME_URL=.*,HOME_URL=\"https://killer-os-oficial.github.io\",' \
        -e 's,DOCUMENTATION_URL=.*,DOCUMENTATION_URL=\"https://killer-os-oficial.github.io/wiki\",' \
        -e 's,SUPPORT_URL=.*,SUPPORT_URL=\"https://t.me/Killer_OS_Info\",' \
        -e 's,BUG_REPORT_URL=.*,BUG_REPORT_URL=\"https://github.com/Killer-OS-Oficial/Killer-OS/issues\",' \
        -e 's,LOGO=.*,LOGO=killer-os,'
}

Issues() {
    sed -i 's|Arch|Killer-OS|g' /etc/issue /usr/share/factory/etc/issue
}
Lsb_release
Os_release
Issues


# sed -i 's?GRUB_DISTRIBUTOR=.*?GRUB_DISTRIBUTOR=\"Killer-OS\"?' /etc/default/grub
# sed -i 's?\#GRUB_THEME=.*?GRUB_THEME=\/boot\/grub\/themes\/crimson\/theme.txt?g' /etc/default/grub
# echo 'GRUB_DISABLE_SUBMENU=y' >> /etc/default/grub
EOF

chmod +x ${work_dir}/settings.sh
chrooter /settings.sh
rm ${work_dir}/settings.sh

echo "==== Done settings.sh ===="
