class N {
private:
	int value;
	char annotation[100];

public:
	N(int val);
	int operator+(const N& other) const;
	int operator-(const N& other) const;
	void setAnnotation(const char* text);
};

N::N(int val) {
	this->value = val;
}

int N::operator+(const N& other) const {
	return this->value + other.value;
}

int N::operator-(const N& other) const {
	return this->value - other.value;
}

void N::setAnnotation(const char* text) {
	size_t length = strlen(text);
	memcpy(this->annotation, text, length);
	this->annotation[length] = '\0';
}

void main(int argc, char *argv[]) {
	if (argc < 2) {
		_exit(1);
	}

	N* firstObject = new N(5);
	N* secondObject = new N(6);

	firstObject->setAnnotation(argv[1]);

	(*reinterpret_cast<void(*)(N*, N*)>(*(void**)(secondObject)))(secondObject, firstObject);

	delete firstObject;
	delete secondObject;
}
