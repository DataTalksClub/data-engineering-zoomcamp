import argparse

def main(params):
    user = params.user
    user1 = params.dois
    print(user, user1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Ingest CSV data to postgres')
    parser.add_argument('user', type=str, help='user name for postgres')
    parser.add_argument('dois', type=str, help='user name for postgres')
    args = parser.parse_args()
    main(args)
