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
            var total_pages = len(pdf.pages)

            print("\nExtracting images from PDF...")

            for page_num in range(total_pages):
                print("\rProcessing page", page_num + 1, "of", total_pages, "...", end="")
                var page = pdf.pages[page_num]
                var images = page.images

                for i in range(len(images)):
                    var image = images[i]
                    var filename = "page" + str(page_num + 1) + "_img" + str(i + 1) + ".png"
                    var image_path = self.os_module.path.join(self.output_dir, filename)

                    var f = self.builtins.open(image_path, "wb")
                    _ = f.write(image["stream"].get_data())
                    _ = f.close()

                    _ = self.extracted_paths.append(image_path)
                    image_count += 1

            print("\rExtraction complete!                    ")  # Extra spaces to clear the line
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

    fn convert_pages(self, pdf_path: String) raises -> Int:
        var start_time = now()
        print("\nConverting PDF pages to images...")

        # Convert PDF pages to images
        var images = self.pdf2image.convert_from_path(pdf_path)
        var total_images = len(images)
        var image_count: Int = 0

        for i in range(total_images):
            print("\rConverting page", i + 1, "of", total_images, "...", end="")
            var image_path = self.os_module.path.join(self.output_dir, "page_" + str(i+1) + ".png")
            _ = images[i].save(image_path)
            _ = self.converted_paths.append(image_path)
            image_count += 1

        print("\rConversion complete!                    ")  # Extra spaces to clear the line
        var end_time = now()
        print("Conversion completed in", end_time - start_time, "seconds")
        return image_count

    fn print_converted_files(self) raises:
        print("\nExtracted files:")
        for path in self.converted_paths:
            print("-", path)

struct PDFTextExtractor:
    var output_dir: String
    var extracted_paths: PythonObject
    var pdfplumber: PythonObject
    var os_module: PythonObject
    var builtins: PythonObject

    fn __init__(inout self, output_dir: String = "extracted_text") raises:
        self.pdfplumber = Python.import_module("pdfplumber")
        self.os_module = Python.import_module("os")
        self.builtins = Python.import_module("builtins")
        self.output_dir = output_dir
        self.extracted_paths = Python.evaluate("[]")

        # Create output directory
        _ = self.os_module.makedirs(output_dir, exist_ok=True)

    fn extract_text(self, pdf_path: String) raises -> Int:
        var start_time = now()
        var pdf = self.pdfplumber.open(pdf_path)
        var total_pages = len(pdf.pages)
        var text_file_count: Int = 0

        print("\nExtracting text from PDF...")

        # Create one file for all pages
        var full_text_path = self.os_module.path.join(self.output_dir, "full_text.txt")
        var full_text_file = self.builtins.open(full_text_path, "w", encoding="utf-8")
        _ = self.extracted_paths.append(full_text_path)
        text_file_count += 1

        # Extract text from each page
        for page_num in range(total_pages):
            print("\rProcessing page", page_num + 1, "of", total_pages, "...", end="")
            var page = pdf.pages[page_num]
            var text = page.extract_text()

            # Write to individual page file
            var page_file_path = self.os_module.path.join(
                self.output_dir,
                "page" + str(page_num + 1) + ".txt"
            )
            var page_file = self.builtins.open(page_file_path, "w", encoding="utf-8")
            _ = page_file.write(text)
            _ = page_file.close()
            _ = self.extracted_paths.append(page_file_path)
            text_file_count += 1

            # Add page text to full text file with page separator
            _ = full_text_file.write("\n\n=== Page " + str(page_num + 1) + " ===\n\n")
            _ = full_text_file.write(text)

        _ = full_text_file.close()
        _ = pdf.close()

        print("\rExtraction complete!                    ")
        var end_time = now()
        print("Text extraction completed in", end_time - start_time, "seconds")
        return text_file_count

    fn print_extracted_files(self) raises:
        print("\nExtracted text files:")
        for path in self.extracted_paths:
            print("-", path)
