from python import Python, PythonObject
from pathlib import Path
from time import now

struct PDFImageExtractor:
    var output_dir: String
    var extracted_paths: PythonObject
    var pdfplumber: PythonObject
    var os_module: PythonObject
    var builtins: PythonObject  # Add this to use Python's built-in functions

    fn __init__(inout self, output_dir: String = "extracted_images") raises:
        self.pdfplumber = Python.import_module("pdfplumber")
        self.os_module = Python.import_module("os")
        self.builtins = Python.import_module("builtins")  # Import Python's built-ins
        self.output_dir = output_dir
        self.extracted_paths = Python.evaluate("[]")

        # Create output directory
        _ = self.os_module.makedirs(output_dir, exist_ok=True)

    fn extract_images(self, pdf_path: String) raises -> Int:
        var start_time = now()
        var pdf = self.pdfplumber.open(pdf_path)
        var image_count: Int = 0

        for page_num in range(len(pdf.pages)):
            var page = pdf.pages[page_num]
            var images = page.images

            for i in range(len(images)):
                var image = images[i]
                var filename = "page" + str(page_num + 1) + "_img" + str(i + 1) + ".png"
                var image_path = self.os_module.path.join(self.output_dir, filename)

                # Use Python's built-in open
                var f = self.builtins.open(image_path, "wb")
                _ = f.write(image["stream"].get_data())
                _ = f.close()

                _ = self.extracted_paths.append(image_path)
                image_count += 1

        _ = pdf.close()
        var end_time = now()
        print("Extraction completed in", end_time - start_time, "seconds")
        return image_count

    fn print_extracted_files(self) raises:
        print("\nExtracted files:")
        for path in self.extracted_paths:
            print("-", path)

struct PDFPageToImageConverter:
    var output_dir: String
    var converted_paths: PythonObject
    var pdf2image: PythonObject
    var os_module: PythonObject

    fn __init__(inout self, output_dir: String = "converted_images") raises:
        self.pdf2image = Python.import_module("pdf2image")
        self.os_module = Python.import_module("os")
        self.output_dir = output_dir
        self.converted_paths = Python.evaluate("[]")

        # Create output directory
        _ = self.os_module.makedirs(output_dir, exist_ok=True)

    fn convert_images(self, pdf_path: String) raises -> Int:
        var start_time = now()

        # Convert PDF pages to images
        var images = self.pdf2image.convert_from_path(pdf_path)
        var image_count: Int = 0

        for i in range(len(images)):
            var image_path = self.os_module.path.join(self.output_dir, "page_" + str(i+1) + ".png")
            _ = images[i].save(image_path)
            _ = self.converted_paths.append(image_path)
            image_count += 1

        var end_time = now()
        print("Conversion completed in", end_time - start_time, "seconds")
        return image_count

    fn print_converted_files(self) raises:
        print("\nExtracted files:")
        for path in self.converted_paths:
            print("-", path)
