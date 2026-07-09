import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/view-model/functions/image_picker.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/notification/notifications_screen.dart';
import 'package:rct/view/notification/notify_model.dart';
import 'package:rct/view/notification/notifycubit.dart';
import 'package:rct/view/notification/states.dart';
import 'package:rct/view/home_screen.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadScreen extends StatefulWidget {
  dynamic NotificationId;
  dynamic file;
  dynamic type;
  dynamic data_id;
  DownloadScreen(
      {super.key,
      required this.NotificationId,
      required this.file,
      required this.data_id,
      required this.type});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  void initState() {
    super.initState();
    print("notification id is ${widget.NotificationId}");
  }

  File? identity;
  bool isLocked = false;
  bool isLoading = false;
  bool _isChecked = false; // Checkbox state

  int downloadCount = 0; // Counter for downloads
  double downloadProgress = 0.0; // Progress variable

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  dynamic filePath;
  Future<void> downloadFile(String url, {String? fileName}) async {
    try {
      // Request storage permissions
      await requestStoragePermission();

      // Set up the path to save the file in the Downloads directory
      Directory? downloadsDirectory;

      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getDownloadsDirectory();
      }

      if (downloadsDirectory == null) {
        throw Exception("Downloads directory is not accessible.");
      }

      // Use the original file name if not provided
      String finalFileName = fileName ?? url.split('/').last;
      filePath = '${downloadsDirectory.path}/$finalFileName';

      // Start downloading
      Dio dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress = received / total;
            });
          }
        },
      );

      // File downloaded successfully
      print("File downloaded successfully to $filePath");

      setState(() {
        downloadCount++;
        downloadProgress = 0.0; // Reset progress after download
      });
      if (Platform.isIOS) {
        final result = await OpenFile.open(filePath);
        print("iOS file open result: ${result.message}");
      }

      if (Platform.isIOS) {
        final url = Uri.file(filePath);

        await launch(url.toString());
      }
      // Open the downloaded file
      final result = await OpenFile.open(filePath);

      print("File opened with result: ${result.message}");
    } catch (e) {
      print("Error downloading file: $e");
      setState(() {
        downloadProgress = 0.0; // Reset progress on error
      });
    }
  }

  String? fileName;

  // bool lol = false;

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0, scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Image.asset(
          "assets/images/photo_2024-09-16_00-14-11.jpg",
          fit: BoxFit.contain,
          width: 100,
          height: 100,
        ),
        // backgroundColor: primaryColor,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationScreen()));
          },
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        builder: (BuildContext context, Object? state) {
          List<NotificationModel> getdata =
              context.read<NotificationCubit>().allDataList;
          final product = getdata.firstWhere(
            (element) => element.id == widget.NotificationId,
          );

          if (product == null) {
            return Center(
              child: Text(""),
            );
          }

          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 150,
                          child: InkWell(
                            onTap: () async {
                              final String? fileUrl = product.titleAr;
                              const String baseUrl =
                                  "$linkServerName"; // Replace with your actual base URL
                              dynamic fullUrl;

                              if (fileUrl != null && fileUrl.isNotEmpty) {
                                fullUrl = Uri.parse(baseUrl)
                                    .resolve(fileUrl.trim())
                                    .toString();
                              }

                              // Debugging: Print the fileUrl and fullUrl

                              if (fullUrl != null &&
                                  Uri.tryParse(fullUrl)?.hasAbsolutePath ==
                                      true) {
                                try {
                                  await downloadFile(
                                    widget
                                        .file, // Pass the full constructed URL
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                          "File downloaded successfully to $filePath"),
                                    ),
                                  );
                                } catch (e) {
                                  print("Error during download: $e");
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.red,
                                      content:
                                          Text("  فشل التحميل , حاول لاحقا")),
                                );
                              }
                            },
                            child: downloadProgress > 0
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: downloadProgress,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "${(downloadProgress * 100).toStringAsFixed(0)}%",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )
                                : Image.network(
                                    "https://th.bing.com/th/id/OIP.VUEgQLuoZq5Dr_xhkOpi2gHaHa?rs=1&pid=ImgDetMain",
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "الرجاء  تحميل المرفق",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(height: constVerticalPadding),
                      InkWell(
                        onTap: () =>
                            pickImageFromGallery(context).then((value) {
                          if (value != null) {
                            setState(() {
                              identity = value;
                            });
                          }
                        }),
                        child: isLocked
                            ? Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Show the image in a dialog when clicked
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.file(
                                                  identity!,
                                                  fit: BoxFit.cover,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Image.file(
                                      identity!,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      // Unlock the image and show the text field again
                                      setState(() {
                                        isLocked = false;
                                        identity = null;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : InkWell(
                                onTap: () =>
                                    pickImageFromGallery(context).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      identity = value;

                                      isLocked =
                                          true; // Lock the image when selected
                                    });
                                  }
                                }),
                                child:
                                    Image.asset("$imagePath/upload-photo.png"),
                              ),
                      ),
                      SizedBox(height: constVerticalPadding),
                      CheckboxListTile(
                        title: Text(
                          local.ireadTermsandiagreeit,
                          style: TextStyle(fontSize: 12),
                        ),
                        value: _isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isChecked =
                                newValue ?? false; // Update checkbox state
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, // Checkbox on the left side
                      ),
                      SizedBox(height: 70),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_isChecked) {
                                await context
                                    .read<NotificationCubit>()
                                    .postNotify(
                                      file: identity,
                                      agreed_terms: 1,
                                      type: widget.type!,
                                      data_id: widget.data_id,
                                    );

                                // lol = true;
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(local
                                          .youhaverejectedthetermsandconditions),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: primaryColor,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: const Text(
                              'قبول',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_isChecked) {
                                await context
                                    .read<NotificationCubit>()
                                    .postNotify(
                                      file: identity,
                                      agreed_terms: 0,
                                      type: widget.type!,
                                      data_id: widget.data_id!,
                                    );
                                print(
                                    "data_id ${product.data.userId}  type: ${product.type} file $identity");

                                // lol = true;
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content:
                                          Text("لقد قمت برفض الشروط والاحكام"),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.grey,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: const Text(
                              'رفض',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is PostLoading) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is PostFailure) {
            setState(() {
              isLoading = false;
              showSnackBar(context, "حدث خطأ حاول مجدداً", Colors.red);
            });
          } else if (state is PostSuccess) {
            isLoading = false;

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowPopUp(
                    title: Center(
                      child: Image.asset(
                        "assets/icons/popUp-icon.png",
                        height: 50.h,
                        width: 50.w,
                      ),
                    ),
                    content: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      // title: Text(local.requestSentSuccessfully),

                      title: Text(
                        "تم إرسال ردك بنجاح شكرا لك",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ontap: () {
                      // Close the current dialog
                      Navigator.of(context, rootNavigator: true).pop();

                      // Navigate to the NotificationScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    });
              },
            );
          }
        },
      ),
    );
  }
}
