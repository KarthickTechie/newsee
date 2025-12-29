# newsee

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## NEW - LOGIN - UI

branch : new branch new-login-ui
created : 16/05/2025
purpose : to integrated and test new-login-ui created by developer @gayathri.b

## New Lead Feature

## Branch Name : new-lead-func

this branch contains UI and features with regards to New Lead - Detalis capturing
which includes forms for sourcing details , personal details , address details , loan details form design

# Ganesh Real Device Testing Comment

flutter run -d RZ8TA0WL7KW

git pull https://github.com/KarthickTechie/newsee.git download-progress-indicator

## proposal workflow

after a successful lead upload , bottom sheet will be open with leadId

step 1 : there show two button left button - Goto LeadInbox Right - CreateProposal

Step 2 : when CreateProposal is clicked show a bottom sheet with circular loader
saying creating proposal for lead Id - Lead/xxxx/xxxxx
Step 3 : once proposal creation is successful show success icon show two buttons
left button - goto proposal Inbox
Rightbutton - goto LandHolding Details

## Master Update

step 1:
to meticulously trace the logs to monitor master update lifecycle
create a auditlog table when login is successful.
id | log_date | time | feature | logdata | errorresponse

---

1 | 26-06-2025 | 10:44 | masterdowload | json string | api / runtime error

logdata = { 'page':'masterdownload','request':'','action':'tabledelete-lovmaster' , data:''}
logdata = { 'page':'masterdownload','request':'apirequest','action':'api-lovmaster' , data:''}
logdata = { 'page':'masterdownload','request':'','action':'tableinsert-lovmaster' , data:''}

step 2 :
create audit log page , have provision to choose date and time window and feature
query auditlog table and show reault as list
on click listtile , show a logdata in table , keep logdata json key to the left of the table
and value to the right column

this way user can see the auditlog data and can identify the rootcause at ease

further download logdata provision and upload to lendperfect server backend to be added

---

## Media Compression Techniques

### 1. WebP Image Compression

**Purpose:** Optimize image file sizes for document uploads while maintaining acceptable visual quality.

**Implementation Location:** [lib/feature/documentupload/presentation/bloc/document_bloc.dart](lib/feature/documentupload/presentation/bloc/document_bloc.dart#L190)

**Library Used:** `flutter_image_compress`

**Compression Method:**
```dart
Future<Uint8List?> convertImageToWebP(String imagePath) async {
  Uint8List originalBytes = await File(imagePath).readAsBytes();
  
  var result = await FlutterImageCompress.compressWithList(
    originalBytes,
    minHeight: 1080,      // Minimum height threshold
    minWidth: 1080,       // Minimum width threshold
    quality: 90,          // Quality level (0-100)
    format: CompressFormat.webp,  // Target format
  );
  return result;
}
```

**Key Features:**
- **Format:** WebP (modern, efficient image format)
- **Quality Setting:** 90/100 (maintains high visual quality with smaller file size)
- **Minimum Dimensions:** 1080x1080 (scales down oversized images)
- **Use Cases:** Document uploads, user identity verification, property images

**Benefits:**
- Reduces file size by 30-50% compared to JPEG
- Faster upload times
- Maintains acceptable image quality for document validation

**Workflow:**
1. User selects image from camera or gallery
2. Image is saved temporarily as JPG
3. WebP conversion is applied automatically
4. Converted file is uploaded to the server with reduced file size

---

### 2. Video Compression

**Purpose:** Reduce video file sizes for efficient storage and transmission of recorded videos.


**Library Used:** `video_compress`

**Compression Method:**
```dart
final mediaInfo = await VideoCompress.compressVideo(
  videoFile.path,
  quality: VideoQuality.DefaultQuality,  // Compression quality setting
  deleteOrigin: false,                    // Preserve original file
);
```

**Key Features:**
- **Quality Setting:** DefaultQuality (optimal balance between size and quality)
- **Compression Format:** MP4 (compatible with most devices)
- **Original File Preservation:** Disabled by default (can be enabled)
- **Recording Duration:** Maximum 15 seconds (auto-stops)
- **Video Codec:** Hardware-accelerated compression when available

**Compression Quality Levels:**
- **LowQuality:** Maximum compression, lowest visual quality (~30-40% of original size)
- **DefaultQuality:** Balanced compression, good visual quality (~50-60% of original size)
- **HighQuality:** Minimal compression, high visual quality (~70-80% of original size)

**Benefits:**
- Reduces video file size significantly (40-70% reduction)
- Faster upload to server
- Reduced storage requirements
- Maintains acceptable video quality for document verification

**Workflow:**
1. User initiates video capture with camera
2. Auto-stop timer triggers after 15 seconds of recording
3. Raw video file is saved temporarily
4. Compression is applied automatically
5. Compressed video is stored and ready for upload

**Additional Metadata Captured:**
- **Captured Date:** Format `DD-MM-YYYY`
- **Captured Time:** Format `HH:MM:SS`
- **GPS Location Details:** Captured during recording initiation
  - Address components (street, locality, postal code, country, etc.)
  - Coordinates (latitude, longitude)

---

### Dependency Configuration

Add the following to `pubspec.yaml` for media compression:

```yaml
dependencies:
  flutter_image_compress: ^2.1.0     # Image compression library
  video_compress: ^3.1.1              # Video compression library
```

---

