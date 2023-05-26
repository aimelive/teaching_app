import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  final UserAccount user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _buildProfileDetailsTile(
      {required String label, required String value, required String iconUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.5),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1a212121),
                  offset: Offset(0, 10),
                  blurRadius: 16,
                  spreadRadius: 0,
                )
              ],
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SvgPicture.asset(iconUrl),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * (0.05),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                        color: secondaryDark,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: secondaryDark,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailsContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 40,
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * (0.25),
              height: MediaQuery.of(context).size.width * (0.25),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.user.profilePic),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.user.names,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18.0),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              "No: 222011935",
              // "${UiUtils.getTranslatedLabel(context, grNumberKey)} - ${widget.studentDetails.admissionNo}",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 12.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * (0.075)),
              child: Divider(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.75),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * (0.075)),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Personal Details",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  _buildProfileDetailsTile(
                    label: "Name",
                    value: widget.user.names,
                    iconUrl: getImagePath("user_pro_class_icon.svg"),
                  ),
                  // _buildProfileDetailsTile(
                  //     label: UiUtils.getTranslatedLabel(context, mediumKey),
                  //     value: UiUtils.formatEmptyValue(widget.user.mediumName),
                  //     iconUrl: UiUtils.getImagePath("medium_icon.svg")),
                  _buildProfileDetailsTile(
                      label: "Role",
                      value: widget.user.role.name,
                      iconUrl: getImagePath("user_pro_roll_no_icon.svg")),
                  _buildProfileDetailsTile(
                      label: "Email",
                      value: widget.user.email,
                      iconUrl: getImagePath("user_pro_dob_icon.svg")),
                  // _buildProfileDetailsTile(
                  //     label: "Picture",
                  //     value: widget.user.profilePic,
                  //     iconUrl: getImagePath("user_pro_address_icon.svg")),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.1),
                  ),
                  const LogoutButton()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const CustomBackAppbar(
          title: "Profile",
        ),
        _buildProfileDetailsContainer(),
      ]),
    );
  }
}

class CustomBackAppbar extends StatelessWidget {
  final String title;

  const CustomBackAppbar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      right: false,
      left: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                popPage(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: whiteColor,
              ),
            ),
            addHorizontalSpace(10),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    color: whiteColor),
              ),
            ),
            addHorizontalSpace(10),
            const SizedBox()
          ],
        ),
      ),
    );
  }
}
